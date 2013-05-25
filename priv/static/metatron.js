var Metatron = (function() {
    var my = {};

    function createAddress() {
        return "ws://" + 
            window.location.host + 
            window.location.pathname +
            "websocket";
    }
    
    my.connect = function() {
        
        var connection = new WebSocket(createAddress());
        connection.onopen = function() {
            connection.send("Ping");
        };

        connection.onerror = function(error) {
            console.log("Error: " + error);
        };

        connection.onmessage = function(e) {
            console.log("Server: " + e.data);
        };
    };
    
    return my;
}());

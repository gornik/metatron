jQuery.fn.serializeObject = function() {
    var arrayData, objectData;
    arrayData = this.serializeArray();
    objectData = {};

    $.each(arrayData, function() {
        var value;

        if (this.value != null) {
            value = this.value;
        } else {
            value = '';
        }

        if (objectData[this.name] != null) {
            if (!objectData[this.name].push) {
                objectData[this.name] = [objectData[this.name]];
            }

            objectData[this.name].push(value);
        } else {
            objectData[this.name] = value;
        }
    });

    return objectData;
};

var Metatron = (function($) {
    var my = {};

    function createAddress() {
        return "ws://" + 
            window.location.host + 
            window.location.pathname +
            "websocket";
    }

    function createStartGameCommand() {
       var formData = $("#gameoptions").serializeObject(); 
       return '{"start_game":' + JSON.stringify(formData) + '}';
    }

    function startGame() {
       $("#startbutton").attr('disabled', 'disabled');

        var connection = new WebSocket(createAddress());
        connection.onopen = function() {
            connection.send(createStartGameCommand());
        };

        connection.onerror = function(error) {
            console.log("Error: " + error);
        };

        connection.onmessage = function(e) {
            console.log("Server: " + e.data);
        };
    };


    
    $("#startbutton").click(function() {
        startGame();
    });

    return my;
}(jQuery));

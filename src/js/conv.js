define(['js/Util'], function (Util) {
    'use strict';

    /**
     * Returns a submatrix from a matrix
     * @param {Array.<Array>} mat Original matrix
     * @param {number} sx Source X
     * @param {number} sy Source Y
     * @param {number} sw Source width
     * @param {number} sh Source height
     * @returns {Array.<Array>}
     */
    function subMat(mat, sx, sy, sw, sh) {
        var ret = [];
        for (var i = 0; i < sh; i++) {
            ret.push([]);
            for (var j = 0; j < sw; j++) {
                ret[i].push(mat[sy + i][sx + j]);
            }
        }
        return ret;
    }

    /**
     * Takes an array and transforms it into a matrix
     * @param {Array} array The array to transform
     * @param {number} width Width of matrix
     * @returns {Array.<Array>}
     */
    function arrayToMat(array, width) {
        var height = array.length / width;
        var mat = [];
        var pointer = 0;
        for (var i = 0; i < height; i++) {
            mat.push([]);
            for (var j = 0; j < width; j++) {
                mat[i].push(array[pointer]);
                pointer++;
            }
        }
        return mat;
    }

    /**
     * Rebuilds am image from a matrix of color indices and a set of indexed colors
     * @param {Array.<Array>} mat
     * @param {Array} indexedColors
     * @param {number} scale
     * @param {CanvasRenderingContext2D} con
     */
    function rebuildImage(mat, indexedColors, scale, con) {
        for (var i = 0; i < mat.length; i++) {
            for (var j = 0; j < mat[i].length; j++) {
                var color = indexedColors[mat[i][j]];
                con.fillStyle = 'rgb(' + color.com + ')';
                con.fillRect(j * scale, i * scale, scale, scale);
            }
        }
    }

    /**
     * Indexes the colors of an image
     * @param {Array} data
     * @returns {{indices: Array, indexedColors: Array}}
     */
    function indexColors(data) {
        var colors = {};
        var indexedColors = [];
        var indices = [];
        var currentIndex = 0;

        for (var i = 0; i < data.length; i += 4) {
            var r = data[i];
            var g = data[i + 1];
            var b = data[i + 2];

            var str = r + ',' + g + ',' + b;
            if (colors[str] === undefined) {
                colors[str] = { freq: 1, index: currentIndex };
                currentIndex++;
                indexedColors.push({ com: str, r: r, g: g, b: b });
            } else {
                colors[str].freq++;
            }
            indices.push(colors[str].index);
        }

        return {
            indices: indices,
            indexedColors: indexedColors
        };
    }

    var alphabet = [
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ];

    /**
     * Transforms a matrix into its string representation
     * @param {Array.<Array>} mat
     * @returns {string}
     */
    function matToString(mat) {
        return mat.reduce(function (prev, cur) {
            return prev + cur.map(function (i) { return alphabet[i]; }).join('') + '\n';
        }, '');
    }

    /**
     * Stringifies all objects gathered from the image
     * @param {Array.<Array>} mat The image
     * @param {number} dim Size of the objects
     * @returns {string}
     */
    function prettyPrintObjects(mat, dim) {
        var lines = Math.floor(mat[0].length / dim);
        var columns = Math.floor(mat.length / dim);

        var strings = [];
        for (var i = 0; i < lines; i++) {
            for (var j = 0; j < columns; j++) {
                strings.push('b_' + i + '_' + j);
                strings.push(matToString(subMat(mat, i * dim, j * dim, dim, dim)));
            }
        }
        return strings.join('\n');
    }

    function getCommonDivisor(width, height) {
        var divisorList = [5, 16, 8, 4, 7, 9, 6, 11, 13];
        var result = Util.findFirst(divisorList, function (d) {
            return (width % d === 0) && (height % d === 0);
        });
        return result.element || 5;
    }

    /**
     * Handles conversions
     * @param {Array} data
     * @param {number} width
     * @param {number} height
     */
    function process(data, width, height) {
        // process the image
        processedImage = indexColors(data);
        mat = arrayToMat(processedImage.indices, width);

        // paint it back
        sheetCanvas = document.createElement('canvas');
        sheetCanvas.width = mat[0].length * scale;
        sheetCanvas.height = mat.length * scale;
        var con = sheetCanvas.getContext('2d');

        rebuildImage(mat, processedImage.indexedColors, scale, con);

        // set dim to some common divisor of width and height
        dim = getCommonDivisor(sheetCanvas.width, sheetCanvas.height);
        paintGrid();

        var dimslider = document.getElementById('dimslider');
        dimslider.value = dim;

        updateString.apply({ value: dim });
    }

    function paintGrid() {
        dropCanvas.width = sheetCanvas.width;
        dropCanvas.height = sheetCanvas.height;

        var con = dropCanvas.getContext('2d');
        con.drawImage(sheetCanvas, 0, 0);

        var lines = Math.floor(mat[0].length / dim);
        var columns = Math.floor(mat.length / dim);

        con.strokeStyle = gridColor;
        con.lineWidth = 1;

        con.beginPath();
        for (var i = 0; i <= lines; i++) {
            con.moveTo(i * dim * scale, 0);
            con.lineTo(i * dim * scale, dropCanvas.height);
        }

        for (var j = 0; j <= columns; j++) {
            con.moveTo(0, j * dim * scale);
            con.lineTo(dropCanvas.width, j * dim * scale);
        }
        con.stroke();
    }

    var sheetCanvas;
    var outTokensEditor, dropCanvas;
    var processedImage, mat;
    var scale = 4;
    var dim = 5;
    var gridColor = '#FFF';

    function updateString() {
        dim = +this.value;

        var dimtext = document.getElementById('dimtext');
        dimtext.value = dim;

        if (!processedImage || !mat) { return; }

        // transform it into text
        var stringedColors = processedImage.indexedColors.reduce(function (prev, cur, index) {
            return prev + alphabet[index] + ' rgb ' + cur.r + ' ' + cur.g + ' ' + cur.b + '\n';
        }, '');
        var stringedObjects = prettyPrintObjects(mat, dim);

        var completeString = 'COLORS\n\n' +
            stringedColors + '\n' +
            'OBJECTS\n\n' +
            stringedObjects;

        // and output it via codemirror
        outTokensEditor.setValue(completeString);

        paintGrid();
    }

    function setupDimInput() {
        var dimElement = document.getElementById('dimslider');
        dimElement.addEventListener('change', updateString);
    }

    /**
     * Converts an image to a buffer of (r, g, b, a) values
     * @param img
     * @returns {CanvasPixelArray}
     */
    function imgToData(img) {
        var canvas = document.createElement('canvas');
        var con = canvas.getContext('2d');
        con.drawImage(img, 0, 0);
        return con.getImageData(0, 0, img.width, img.height).data;
    }

    /**
     * Enables file drag-and-drop on the 'drop canvas'
     */
    function setupDropEventListener() {
        function cancel(e) {
            if (e.preventDefault) { e.preventDefault(); }
            return false;
        }

        dropCanvas.addEventListener('dragover', cancel);
        dropCanvas.addEventListener('dragenter', cancel);

        dropCanvas.addEventListener('drop', function (e) {
            e.preventDefault();

            var files = e.dataTransfer.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var reader = new FileReader();

                reader.readAsDataURL(file);
                reader.addEventListener('loadend', function (e) {
                    // get the image
                    var img = document.createElement('img');
                    img.src = this.result;

                    // paint the image to some canvas to get the pixel data
                    var imageData = imgToData(img);

                    // process the pixel data
                    process(imageData, img.width, img.height);
                });
            }
            return false;
        });
    }

    /**
     * Sets up the codemirror editor where the result is shown
     */
    function setupEditors() {
        outTokensEditor = CodeMirror.fromTextArea(document.getElementById('outobjects'), {
            lineNumbers: true,
            styleActiveLine: true,
            readOnly: true
        });
        outTokensEditor.setSize(400, 500);
        outTokensEditor.setOption('theme', 'cobalt');
    }

    /**
     * Prepares the file 'drop canvas'
     */
    function setupDropZone() {
        dropCanvas = document.getElementById('drop');
        dropCanvas.width = 200;
        dropCanvas.height = 128;
        var con = dropCanvas.getContext('2d');

        con.fillStyle = '#FFF';
        con.fillRect(0, 0, dropCanvas.width, dropCanvas.height);

        con.strokeStyle = '#000';
        con.beginPath();
        con.moveTo(0, 0); con.lineTo(dropCanvas.width, dropCanvas.height);
        con.moveTo(dropCanvas.width, 0); con.lineTo(0, dropCanvas.height);
        con.stroke();
    }

    /**
     * Main starting point
     */
    function run() {
        setupDimInput();
        setupDropZone();
        setupEditors();
        setupDropEventListener();
    }

    return { run: run };
});
var webdriver=require('selenium-webdriver'),
By = webdriver.By,
until = webdriver.until;
var Tesseract=require('tesseract.js');

module.exports = function () {

    // the main problem is the canvas, so we're using coordinate to click the button
    const coordinate = [
        {x:59,y:492}, //0
        {x:59,y:436}, //1
        {x:150,y:436}, //2
        {x:236,y:436}, //3
        {x:59,y:347}, //4
        {x:150,y:347}, //5
        {x:236,y:347}, //6
        {x:59,y:260}, //7
        {x:150,y:260}, //8
        {x:236,y:260}, //9
        {x:323, y:435}, //10 = min
        {x:323, y:263}, //11 = division
        {x:409, y:170}, //12 = CE
        {x:409, y:524}, //13 = equal
    ];

    //var canvas;

    this.Given(/^Open chrome browser and start application$/, function () {
        try{
            return driver.get('https://www.online-calculator.com/full-screen-calculator/');
        } catch (err) {
            console.log(err);
        }
    });

    this.When(/^I press following button$/, function (dataTable) {
        try{
            driver.wait(until.elementsLocated(By.id('fullframe')),5000);
            iframe = driver.findElement(By.id('fullframe'));
            driver.switchTo().frame(iframe);
            canvas = driver.findElement(By.id('canvas'));
            pressButtonChain(canvas, dataTable.raw());
        } catch (err) {
            console.log(err);
        }
    });

    this.Then(/^I should be able to see$/, function (dataTable, callback) {
        worker = Tesseract.createWorker({
          logger: m => console.log(m), // Add logger here
        });

        (async () => {
            try{
                await takeResult();
                await worker.load();
                await worker.loadLanguage('eng');
                await worker.initialize('eng');
                const { data: { text } } = await worker.recognize('reports/out.png');
                console.log(text);
                val = text.replace('\n','');
                await worker.terminate();
                assert.equal(dataTable.raw()[0][1],val);
                callback();
            } catch (err) {
                console.log(err);
                callback(err);
            }
        })();
    });

    function pressButtonChain (canvas, arrayOfButton) {
        actions = driver.actions();
        for (i=0;i<arrayOfButton.length;i++) {
            if (arrayOfButton[i][0] == "-"){
                actions.mouseMove(canvas,coordinate[10]).click();
            } else if (arrayOfButton[i][0] == "/"){
                actions.mouseMove(canvas,coordinate[11]).click();
            } else if (arrayOfButton[i][0] == "CE"){
                actions.mouseMove(canvas,coordinate[12]).click();
            } else if (arrayOfButton[i][0] == "="){
                actions.mouseMove(canvas,coordinate[13]).click();
            } else {
                for (j=0;j<arrayOfButton[i][0].length;j++) {
                    actions.mouseMove(canvas,coordinate[parseInt(arrayOfButton[i][0].charAt(j))]).click();
                }
            }
        }
        actions.perform();
    }

    function takeScreenshot() {

        driver.takeScreenshot().then(function (buffer) {
            return this.attach(new Buffer(buffer, 'base64'), 'image/png');
        });
    }

    function takeResult() {
        const fs = require("fs");
        var now = new Date().getTime();
        imagePath="./reports/out.png";
        var base64Data = "";
        var location = {};
        location.x = 1000;
        location.y = 75;
        location.height = 100;
        location.width = 780;
        var bulk = [];
        driver.then(_ => {
            driver.manage().window().getSize().then(e => {
                location.browserHeight = e.height;
                location.broserWidth = e.width;
            });
        }).then(_ => {
            driver.takeScreenshot().then(data => {
                base64Data = data.replace(/^data:image\/png;base64,/, "");
            });
        }).then(_ => {
            const sizeLimit = 700000; // around 700kb
            const imgSize = base64Data.length;
            driver.executeScript(() => {
                window.temp = new Array;
            }).then(_ => {
                for (var i = 0; i < imgSize; i += sizeLimit) {
                    bulk.push(base64Data.substring(i, i + sizeLimit));
                }
                bulk.forEach((element, index) => {
                    driver.executeScript(() => {
                        window.temp[arguments[0]] = arguments[1];
                    }, index, element);
                });
            });
        }).then(_ => {
            driver.executeScript(() => {
                var tempBase64 = window.temp.join("");
                var image = new Image();
                var location = arguments[0];
                image.src = "data:image/png;base64," + tempBase64;
                image.onload = function () {
                    var canvas = document.createElement("canvas");
                    canvas.height = location.height;
                    canvas.width = location.width;
                    canvas.style.height = location.height + 'px';
                    canvas.style.width  = location.width + 'px';
                    var ctx = canvas.getContext('2d');
                    ctx.drawImage(image, -location.x, -location.y);
                    window.canvasData = canvas.toDataURL();
                    window.temp = [];
                }
            }, location);
        }).then(_ => {
            return driver.executeScript(() => {
                var data = window.canvasData;
                window.canvasData = "";
                return data;
            }).then(data => {
                var tempData = data.replace(/^data:image\/png;base64,/, "");
                fs.writeFileSync(imagePath, tempData, "base64");
            });
        });
    }
};
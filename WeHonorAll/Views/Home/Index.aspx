<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>We Honor All</title>
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<style>
* {
  margin: 0px;
  padding: 0px;
}

body {
  background-color: white;
  font-family: Helvetica, Arial, sans-serif;
  font-size: 10pt;
  color: #424037;
}

#centered {
  position: relative;
  width: 784px;
  left: 50%;
  margin-left:-372px;
}

#feed {
  float: right;
  margin-top: 34px;
  width: 386px;
  height: 228px;
  overflow: hidden;
  background-image: url('/Content/images/feed.png');
  padding-top: 13px;
  padding-bottom: 13px;
  padding-right: 13px;
}

.tweet {
    min-height: 48px;
    margin-bottom: 15px;
    margin-left: 15px;
}

.tweet-image {
    margin-top: 3px;
    float: left;
    height: 48px;
    width: 48px;
}

.tweet-content {
    min-height: 48px;
    margin-left: 58px;
}

.tweet-row {
    line-height: 15px;
    position: relative;
}

.tweet-username {
    color: #333;
    font-weight: bold;
    font-size: 15px;
    font-family: Arial, Helvetica, sans-serif;
}

.tweet-fullname {
    color: #999;
    font-size: 12px;
}

.tweet-time {
    color: #999;
    font-size: 11px;
}

#topbox {
    margin-top: 68px;
    width: 785px;
    height: 360px;
    background-image: url('/Content/images/topbox.png');
    overflow: hidden;
}

#results {
    position: absolute;
    width: 214px;
    height: 114px;
    overflow: hidden;
    font-size: 12px;
    padding: 5px;
}

.result {
    padding: 3px;
    width: 197px;
    line-height: 1.2em;
    cursor: pointer;
}

input {
    border: 0px;
}

input:focus {
    outline: none;
}

.selected {
    background-color: #5A87C6;
    color: white;
}

.d_link {
  background-color: white;
  filter: alpha(opacity=0);
  opacity: 0.0;
  position: absolute;
  cursor: pointer;
}

.dot {
    position: absolute;
    width: 7px;
    height: 7px;
    background-image: url('/Content/images/dot.png');
}

#us {
    position: relative;
    margin-top: 34px;
    float: left;
    width: 347px;
    height: 253px;
    background-image: url('/Content/images/us.png');
}

#firstpage, #tweetpage, #thankyou {
    position: absolute;
    margin-top: 10px;
    margin-left: 10px;
    width: 740px;
    height: 327px;
}

#firstpage {
    background: transparent url('/Content/images/firstpage.png') no-repeat;
}

#tweetpage {
    display: none;
}

#thankyou {
    display: none;
    background: transparent url('/Content/images/thankyou.png') no-repeat;
}

#tweetbox {
    border: 0px;
    position: absolute;
    left: 30px;
    top: 85px;
    height: 137px;
    width: 434px;
    font-size: 20px;
}

#tweetbox:focus {
    outline: none;
}

#chosenone {
    color: #999999;
    font-size: 40px;
    font-family: "Trebuchet MS", sans-serif;
}   
</style>
       
<script type="text/javascript">
    /**
    * jQuery.timers - Timer abstractions for jQuery
    * Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com)
    * Licensed under the WTFPL (http://sam.zoy.org/wtfpl/).
    * Date: 2009/10/16
    *
    * @author Blair Mitchelmore
    * @version 1.2
    *
    **/

    jQuery.fn.extend({
        everyTime: function (interval, label, fn, times) {
            return this.each(function () {
                jQuery.timer.add(this, interval, label, fn, times);
            });
        },
        oneTime: function (interval, label, fn) {
            return this.each(function () {
                jQuery.timer.add(this, interval, label, fn, 1);
            });
        },
        stopTime: function (label, fn) {
            return this.each(function () {
                jQuery.timer.remove(this, label, fn);
            });
        }
    });

    jQuery.extend({
        timer: {
            global: [],
            guid: 1,
            dataKey: "jQuery.timer",
            regex: /^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,
            powers: {
                // Yeah this is major overkill...
                'ms': 1,
                'cs': 10,
                'ds': 100,
                's': 1000,
                'das': 10000,
                'hs': 100000,
                'ks': 1000000
            },
            timeParse: function (value) {
                if (value == undefined || value == null)
                    return null;
                var result = this.regex.exec(jQuery.trim(value.toString()));
                if (result[2]) {
                    var num = parseFloat(result[1]);
                    var mult = this.powers[result[2]] || 1;
                    return num * mult;
                } else {
                    return value;
                }
            },
            add: function (element, interval, label, fn, times) {
                var counter = 0;

                if (jQuery.isFunction(label)) {
                    if (!times)
                        times = fn;
                    fn = label;
                    label = interval;
                }

                interval = jQuery.timer.timeParse(interval);

                if (typeof interval != 'number' || isNaN(interval) || interval < 0)
                    return;

                if (typeof times != 'number' || isNaN(times) || times < 0)
                    times = 0;

                times = times || 0;

                var timers = jQuery.data(element, this.dataKey) || jQuery.data(element, this.dataKey, {});

                if (!timers[label])
                    timers[label] = {};

                fn.timerID = fn.timerID || this.guid++;

                var handler = function () {
                    if ((++counter > times && times !== 0) || fn.call(element, counter) === false)
                        jQuery.timer.remove(element, label, fn);
                };

                handler.timerID = fn.timerID;

                if (!timers[label][fn.timerID])
                    timers[label][fn.timerID] = window.setInterval(handler, interval);

                this.global.push(element);

            },
            remove: function (element, label, fn) {
                var timers = jQuery.data(element, this.dataKey), ret;

                if (timers) {

                    if (!label) {
                        for (label in timers)
                            this.remove(element, label, fn);
                    } else if (timers[label]) {
                        if (fn) {
                            if (fn.timerID) {
                                window.clearInterval(timers[label][fn.timerID]);
                                delete timers[label][fn.timerID];
                            }
                        } else {
                            for (var fn in timers[label]) {
                                window.clearInterval(timers[label][fn]);
                                delete timers[label][fn];
                            }
                        }

                        for (ret in timers[label]) break;
                        if (!ret) {
                            ret = null;
                            delete timers[label];
                        }
                    }

                    for (ret in timers) break;
                    if (!ret)
                        jQuery.removeData(element, this.dataKey);
                }
            }
        }
    });

    jQuery(window).bind("unload", function () {
        jQuery.each(jQuery.timer.global, function (index, item) {
            jQuery.timer.remove(item);
        });
    });

    var services = [
    "Army",
    "Air Force",
    "Navy",
    "Marine Corps",
];

    var ranks = [
["Pvt", (1 - 0.1465) * 0.142],
["PFC", (1 - 0.1465) * 0.141],
["Cpl", (1 - 0.1465) * 0.268],
["Sgt", (1 - 0.1465) * 0.182],
["SSgt", (1 - 0.1465) * 0.141],
["SFC", (1 - 0.1465) * 0.092],
["MSgt", (1 - 0.1465) * 0.026],
["SgtMaj", (1 - 0.1465) * 0.008],
["2ndLt", 0.1465 * 0.131],
["1stLt", 0.1465 * 0.132],
["Capt", 0.1465 * 0.327],
["Maj", 0.1465 * 0.214],
["LtCol", 0.1465 * 0.137],
["Col", 0.1465 * 0.056],
["BGen", 0.1465 * 0.032],
["MGen", 0.1465 * 0.020],
["LtGen", 0.1465 * 0.009],
["Gen", 0.1465 * 0.002],
];

    var lastNames = [
    "Smith",
    "Johnson",
    "Williams",
    "Jones",
    "Brown",
    "Davis",
    "Miller",
    "Wilson",
    "Moore",
    "Taylor",
    "Anderson",
    "Thomas",
    "Jackson",
    "White",
    "Harris",
    "Martin",
    "Thompson",
    "Garcia",
    "Martinez",
    "Robinson",
    "Clark",
    "Rodriguez",
    "Lewis",
    "Lee",
    "Walker",
    "Hall",
    "Allen",
    "Young",
    "Hernandez",
    "King",
    "Wright",
    "Lopez",
    "Hill",
    "Scott",
    "Green",
    "Adams",
    "Baker",
    "Gonzalez",
    "Nelson",
    "Carter",
    "Mitchell",
    "Perez",
    "Roberts",
    "Turner",
    "Phillips",
    "Campbell",
    "Parker",
    "Evans",
    "Edwards",
    "Collins",
    "Stewart",
    "Sanchez",
    "Morris",
    "Rogers",
    "Reed",
    "Cook",
    "Morgan",
    "Bell",
    "Murphy",
    "Bailey",
    "Rivera",
    "Cooper",
    "Richardson",
    "Cox",
    "Howard",
    "Ward",
    "Torres",
    "Peterson",
    "Gray",
    "Ramirez",
    "James",
    "Watson",
    "Brooks",
    "Kelly",
    "Sanders",
    "Price",
    "Bennett",
    "Wood",
    "Barnes",
    "Ross",
    "Henderson",
    "Coleman",
    "Jenkins",
    "Perry",
    "Powell",
    "Long",
    "Patterson",
    "Hughes",
    "Flores",
    "Washington",
    "Butler",
    "Simmons",
    "Foster",
    "Gonzales",
    "Bryant",
    "Alexander",
    "Russell",
    "Griffin",
    "Diaz",
    "Hayes",
];

    var firstNames = [
    "Michael",
    "Christopher",
    "Matthew",
    "Joshua",
    "Daniel",
    "David",
    "Andrew",
    "James",
    "Justin",
    "Joseph",
    "Ryan",
    "John",
    "Robert",
    "Nicholas",
    "Anthony",
    "William",
    "Jonathan",
    "Kyle",
    "Brandon",
    "Jacob",
    "Tyler",
    "Zachary",
    "Kevin",
    "Eric",
    "Steven",
    "Thomas",
    "Brian",
    "Alexander",
    "Jordan",
    "Timothy",
    "Cody",
    "Adam",
    "Benjamin",
    "Aaron",
    "Richard",
    "Patrick",
    "Sean",
    "Charles",
    "Stephen",
    "Jeremy",
    "Jose",
    "Travis",
    "Jeffrey",
    "Nathan",
    "Samuel",
    "Mark",
    "Jason",
    "Jesse",
    "Paul",
    "Dustin",
    "Jessica",
    "Ashley",
    "Brittany",
    "Amanda",
    "Samantha",
    "Sarah",
    "Stephanie",
    "Jennifer",
    "Elizabeth",
    "Lauren",
    "Megan",
    "Emily",
    "Nicole",
    "Kayla",
    "Amber",
    "Rachel",
    "Courtney",
    "Danielle",
    "Heather",
    "Melissa",
    "Rebecca",
    "Michelle",
    "Tiffany",
    "Chelsea",
    "Christina",
    "Katherine",
];

    var usernames = [
    "Fannie_Mossiei",
    "iAmMissKarma",
    "djbull7",
    "austenmc",
    "GREGsoLOKO",
    "cindeetl",
    "The_Read_Redboy",
    "CaylaAmari",
    "EmilyZager",
    "Swagrite93",
    "HURDLEKIDZ",
    "CsmithAlways",
    "NicKovalchuk",
    "Leannegip",
    "Smooth_with_it",
    "IamSpectacular",
    "DeusUrHynest",
    "UCanCallMeRuby",
    "kfp24",
    "baltimoresbest",
    "DeyiyesHaughton",
    "rayastryder",
    "sc_weeks",
    "funnyorfact",
    "dancerkat86",
    "PCroas",
    "silkin_floss412",
    "Philknowsbest",
    "DJPaulyD",
    "LeJael",
    "AJEnglish",
    "pourmecoffee",
    "mathewi",
    "Jennifer_Heidi",
    "sp0rk",
    "GaryNaz",
    "scooterbraun",
    "satheadlines",
    "PaulyP",
    "BobbyPysar",
    "GrindTymeV",
    "justmindyy",
    "jaime__garcia",
    "Beautiful_P",
    "KedaLee",
    "free_state",
    "raul_alex",
    "Christen2789",
    "liquidideal",
    "AeroStar24",
    "Earlene2020",
    "LAmonsterOK",
    "lilsoclassy",
    "Manda7215",
    "rennithfer",
    "markgougeon",
    "ATXvato",
];

    var towns = [
"Franklin",
"Clinton",
"Springfield",
"Greenville",
"Salem",
"Fairview",
"Madison",
"Washington",
"Georgetown",
"Arlington",
"Ashland",
"Burlington",
"Manchester",
"Marion",
"Oxford",
"Clayton",
"Jackson",
"Milton",
"Auburn",
"Dayton",
"Lexington",
"Milford",
"Riverside",
"Cleveland",
"Dover",
"Hudson",
"Kingston",
"Mount Vernon",
"Newport",
"Oakland",
"Centerville",
"Winchester",
];

    var states = [
"AK",
"AL",
"AR",
"AZ",
"CA",
"CO",
"CT",
"DE",
"FL",
"GA",
"HI",
"IA",
"ID",
"IL",
"IN",
"KS",
"KY",
"LA",
"MA",
"MD",
"ME",
"MI",
"MN",
"MO",
"MS",
"MT",
"NC",
"ND",
"NE",
"NH",
"NJ",
"NM",
"NV",
"NY",
"OH",
"OK",
"OR",
"PA",
"RI",
"SC",
"SD",
"TN",
"TX",
"UT",
"VA",
"VT",
"WA",
"WI",
"WV",
"WY",
];

    var messages = [
    "Honoring [member] from [town], [state], for serving #WeHonorAll",
    "Big hello [member] from the great state of [state]  #WeHonorAll",
    "Hello to my child [member] who is serving overseas #WeHonorAll",
    "Greetings and salutations to [member] from [town], [state], for serving #WeHonorAll",
    "Shout out to [member] from [town], [state], for protecting us #WeHonorAll",
    "Honoring [member] from [state], for standing as sword and shield #WeHonorAll",
    "Honoring [member] from [town], [state], for serving #WeHonorAll",
    "Thanking [member] from the great state of [state], for serving our country #WeHonorAll",
    "Thanks [member] for keeping us safe #WeHonorAll",
    "Appreciate what you're doing [member]  #WeHonorAll",
    "[member] thanks for sacrificing some of your freedom for ours #WeHonorAll",
    "Supporting [member] from [town], [state], for protecting us #WeHonorAll",
    "Honoring [member] from [state], for serving overseas #WeHonorAll",
];

    var avatars = [
"Content/images/chuckmallott.jpg",
"Content/images/giblanco.jpg",
"Content/images/linux29.jpg",
"Content/images/stevethegreat.jpg",
"Content/images/derenix.jpg",
"Content/images/idealic.jpg",
"Content/images/mj12982.jpg",
"Content/images/thiagoegg.jpg",
"Content/images/designdan.jpg",
"Content/images/ivanrubio.jpg",
"Content/images/mnchknlady.jpg",
"Content/images/wagit.jpg",
"Content/images/doubleolee.jpg",
"Content/images/lealea.jpg",
"Content/images/samicamacho.jpg",
"Content/images/zeldman.jpg",
"Content/images/basibanget.png",
"Content/images/naldzgraphics.png",
"Content/images/cabel.png",
"Content/images/ralphjoson.png",
"Content/images/danielmall.png",
"Content/images/lelethielen.png",
"Content/images/whitefer.png",
];

    var rankHistogram = [];
    for (var i = 0; i < ranks.length; i++) {
        if (i > 0) {
            rankHistogram[i] = rankHistogram[i - 1] + ranks[i][1];
        } else {
            rankHistogram[i] = ranks[i][1];
        }
    }

    function randomService() {
        return services[Math.floor(Math.random() * services.length)];
    }

    function randomRank() {
        var r = Math.random();
        for (var i = 0; i < rankHistogram.length; i++) {
            if (r < rankHistogram[i]) {
                return ranks[i][0];
            }
        }
    }

    function randomFirstName() {
        return firstNames[Math.floor(Math.random() * firstNames.length)];
    }

    function randomLastName() {
        return lastNames[Math.floor(Math.random() * lastNames.length)];
    }

    function randomName() {
        return randomFirstName() + " " + randomLastName();
    }

    function randomUsername() {
        return usernames[Math.floor(Math.random() * usernames.length)];
    }

    function randomState() {
        return states[Math.floor(Math.random() * states.length)];
    }

    function randomTown() {
        return towns[Math.floor(Math.random() * towns.length)];
    }

    function randomTweet(member, state, town) {
        var t = messages[Math.floor(Math.random() * messages.length)];
        return t.replace("[member]", member)
            .replace("[state]", state)
            .replace("[town]", town);
    }

    function twitterImage() {
        return avatars[Math.floor(Math.random() * avatars.length)];
    }

    function makeFeed(username, fullname, image, tweet) {
        var f = $("<div>");
        f.addClass("tweet");
        f.html(
        '<div class="tweet-image"><img src="' + image + '"></div><div class="tweet-content">' +
            '<div class="tweet-row"><span class="tweet-username">' + username + '</span>&nbsp;<span class="tweet-fullname">' + fullname + '</span></div>' +
            '<div class="tweet-row" style="line-height:19px">' + tweet + '</div>' +
            '<div class="tweet-row"><span class="tweet-time">a moment ago</span></div>' +
        '</div>');

        return f;
    }

    var boxes = [
    [[26, 21], [26 + 112, 21 + 107]],
    [[140, 84], [144 + 144, 84 + 65]],
    [[139, 22], [139 + 54, 22 + 62]],
    [[65, 129], [65 + 73, 129 + 26]],
    [[123, 156], [123 + 159, 156 + 13]],
    [[299, 41], [299 + 26, 41 + 23]],
    [[278, 66], [278 + 26, 66 + 19]],
];

    function postFeed(justadded) {
        justadded.css("display", "none");
        $("#feed").prepend(justadded);
        justadded.fadeIn("slow", null);

        var dot = $("<div>");
        dot.addClass("dot");

        // find a random box...
        var b = boxes[Math.floor(Math.random() * boxes.length)];
        dot.css("top", Math.floor(Math.random() * (b[1][1] - b[0][1])) + b[0][1] + "px")
       .css("left", Math.floor(Math.random() * (b[1][0] - b[0][0])) + b[0][0] + "px");
        $("#us").prepend(dot);

        dot.oneTime(15000, function () { $(this).fadeOut("slow", null); });
    }

    function tmp() {
        var u = randomUsername();
        postFeed(makeFeed(u, randomName(), twitterImage(), randomTweet(randomRank() + " " + randomName(), randomState(), randomTown())));
        feedTimer();
    }

    function feedTimer() {
        // loops perpetually...
        var t = Math.floor(Math.random() * 2000.0) + 2000.0;
        setTimeout("tmp()", t);
    }

    function search() {
        var name = randomRank() + " " + randomFirstName() + " " + $("#name").val();
        var result = $("<div>");
        var state = $("#state").val();
        if (state.length == 0) {
            state = randomState();
        }
        result.addClass("result");
        result.bind("click", function () {
            result.addClass("selected");
            $("#chosenone").html(name);
            $("#tweetbox").html(randomTweet(name, state, randomTown()));
            $("#firstpage").fadeOut("slow", function () {
                $("#tweetpage").fadeIn("slow");
            });
        });
        result.html(name);
        $("#results").html("");
        $("#results").prepend(result);
    }

    function selectRandom() {
        var name = randomRank() + " " + randomName();
        $("#chosenone").html(name);
        $("#tweetbox").html(randomTweet(name, randomState(), randomTown()));
        $("#firstpage").fadeOut("slow", function () {
            $("#tweetpage").fadeIn("slow");
        });
    }


    function tweet() {
        postFeed(makeFeed("rdhjr", "RD Huffstetler", "http://a2.twimg.com/profile_images/682386295/13336_331404515590_800720590_9713299_1184240_n_normal.jpg", $("#tweetbox").val()));
        $("#tweetpage").fadeOut("slow", function () {
            $("#thankyou").fadeIn("slow");
        });
    }

    $(document).ready(function () {
        $("#feeds").prepend(makeFeed());
        $("#feeds").prepend(makeFeed());
        $("#feeds").prepend(makeFeed());
        $("#feeds").prepend(makeFeed());

        feedTimer();
    });

    function show(id) {
        var d = $(document.body);

        $("#shroud").css("top", "0px")
              .css("left", "0px")
              .css("width", d.outerWidth() + "px")
              .css("height", d.outerHeight() + "px")
              .css("z-index", 500);

        $("#shroud").fadeIn("slow", function () {
            var e = $("#" + id);
            e.css("left", d.outerWidth() / 2 - e.outerWidth() / 2 + "px")
       .css("z-index", 600);

            e.fadeIn("slow", function () { });
        });
    }

    function hide(id) {
        var e = $("#" + id);
        e.fadeOut("400", function () {
            $("#shroud").fadeOut("400", function () { });
        });
    }

    function flip(postit) {
        /*  $("#"+postit).css("z-index", "0");
        $("#"+postit+"-over").css("z-index", "100");*/
        $("#" + postit + "-over").css("display", "block");
        $("#" + postit).css("display", "none");
    }

    function unflip(postit) {
        $("#" + postit).css("display", "block");
        $("#" + postit + "-over").css("display", "none");
    }
</script>

</head>
<body>
    <div id="shroud"></div>
    <div id="centered">
        <div id="topbox">
            <div id="firstpage">
                <input id="name" type="text" style="position: absolute; left: 70px; top: 50px; width: 147px; height: 21px"/>
                <input id="state" type="text" style="position: absolute; left: 70px; top: 92px; width: 147px; height: 21px"/>
                <input id="service" type="text" style="position: absolute; left: 70px; top: 129px; width: 147px; height: 21px"/>
                <div class="d_link" style="width: 183px; height: 48px; top: 76px; left: 276px;" onclick="selectRandom()">&nbsp;</div>

                <div class="d_link" style="width: 59px; height: 26px; top: 165px; left: 161px;" onclick="search()">&nbsp;</div>
                <div id="results" style="top: 212px; left: 9px;">
                </div>
            </div>
            <div id="tweetpage">
                <div id="chosenone"></div>
                <img src="Content/images/tweetbox.png" style="width: 718px; height: 194px; position: absolute; left: 20px; top: 75px;"/>
                <div class="d_link" style="width: 59px; height: 26px; top: 242px; left: 404px;" onclick="tweet()">&nbsp;</div>
                <textarea id="tweetbox"></textarea>

            </div>
            <div id="thankyou"></div>
        </div>
        <div id="us">
        </div>
        <div id="feed">
        </div>
        <img style="margin-top: 34px; margin-bottom: 34px;" src="Content/images/mostactive.png"/>
    </div>

</body>
</html>



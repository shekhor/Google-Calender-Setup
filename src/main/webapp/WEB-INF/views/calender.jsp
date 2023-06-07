<!DOCTYPE html>
<html>
<head>
    <title>Google Calendar API Quickstart</title>
    <meta charset="utf-8" />
</head>
<body>
<p>Google Calendar API Quickstart</p>

<!--Add buttons to initiate auth sequence and sign out-->
<button id="authorize_button" style="display: none;">Authorize</button>
<button id="show_events" style="display: none;">show events</button>

<button id="create_events" style="display: none;">create event</button>

<button id="signout" style="display: none;">sign out</button>

<pre id="content" style="white-space: pre-wrap;"></pre>

<script type="text/javascript">
    // Client ID and API key from the Developer Console
    var CLIENT_ID = '138279268322-bbggup40cec15e0p56o5spv4cmi7m1ct.apps.googleusercontent.com';
    var API_KEY = 'AIzaSyACq2pcSZoHam3HAsXTWIPGj8U4056x88g';

    // Array of API discovery doc URLs for APIs used by the quickstart
    var DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];

    // Authorization scopes required by the API; multiple scopes can be
    // included, separated by spaces.
    var SCOPES = "https://www.googleapis.com/auth/calendar";

    var authorizeButton = document.getElementById('authorize_button');
    var showEventButton = document.getElementById('show_events');
    var createButton = document.getElementById('create_events');
    var signoutButton = document.getElementById('signout');

    /**
     *  On load, called to load the auth2 library and API client library.
     */
    function handleClientLoad() {
        gapi.load('client:auth2', initClient);
    }

    /**
     *  Initializes the API client library and sets up sign-in state
     *  listeners.
     */
    function initClient() {
        gapi.client.init({
            apiKey: API_KEY,
            clientId: CLIENT_ID,
            discoveryDocs: DISCOVERY_DOCS,
            scope: SCOPES
        }).then(function () {
            // Listen for sign-in state changes.
            gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);
            GoogleAuth = gapi.auth2.getAuthInstance();
            var GoogleUser = GoogleAuth.currentUser.get();
            GoogleUser.grant({'scope': SCOPES});

            // Handle the initial sign-in state.
            updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
            authorizeButton.onclick = handleAuthClick;
            createButton.onclick = handleCreateClick;
            showEventButton.onclick = handleUpcommingEventClick;
            signoutButton.onclick = handleSignoutClick;
        }, function(error) {
            appendPre(JSON.stringify(error, null, 2));
        });
    }

    /**
     *  Called when the signed in status changes, to update the UI
     *  appropriately. After a sign-in, the API is called.
     */
    function updateSigninStatus(isSignedIn) {
        if (isSignedIn) {
            authorizeButton.style.display = 'none';
            createButton.style.display = 'block';
            showEventButton.style.display = 'block';
            signoutButton.style.display = 'block';
        } else {
            authorizeButton.style.display = 'block';
            createButton.style.display = 'none';
            showEventButton.style.display = 'none';
            signoutButton.style.display = 'none';
        }
    }

    /**
     *  Sign in the user upon button click.
     */
    function handleAuthClick(event) {
        gapi.auth2.getAuthInstance().signIn()

    }

    function handleSignoutClick(event) {
        gapi.auth2.getAuthInstance().signOut();
    }


    /**
     *  Sign out the user upon button click.
     */
    function handleCreateClick(event) {

        createEvent();
    }

    function handleUpcommingEventClick(event) {

        listUpcomingEvents();
    }

    /**
     * Append a pre element to the body containing the given message
     * as its text node. Used to display the results of the API call.
     *
     * @param {string} message Text to be placed in pre element.
     */
    function appendPre(message) {
        var pre = document.getElementById('content');
        var textContent = document.createTextNode(message + '\n');
        pre.appendChild(textContent);
    }

    /**
     * Print the summary and start datetime/date of the next ten events in
     * the authorized user's calendar. If no events are found an
     * appropriate message is printed.
     */
    function listUpcomingEvents() {
        console.log("upcomming events");
        gapi.client.calendar.events.list({
            'calendarId': 'primary',
            'timeMin': (new Date()).toISOString(),
            'timeMax': '2020-12-29T09:00:00-07:00',
            'showDeleted': false,
            'singleEvents': true,
            'maxResults': 10,
            'orderBy': 'startTime'
        }).then(function(response) {
            var events = response.result.items;
            appendPre('Upcoming events:');

            if (events.length > 0) {
                for (i = 0; i < events.length; i++) {
                    var event = events[i];
                    var when = event.start.dateTime;
                    if (!when) {
                        when = event.start.date;
                    }
                    appendPre(event.summary + ' (' + when + ')')
                }
            } else {
                appendPre('No upcoming events found.');
            }
        });
    }

    function createEvent() {
        var event = {
            'summary': 'Google I/O 2015',
            'description': 'A chance to hear more about Google\'s developer products.',
            'start': {
                'dateTime': '2020-11-28T09:00:00-07:00',
                'timeZone': '(GMT+06:00) Bangladesh Standard Time'
            },
            'end': {
                'dateTime': '2020-11-28T17:00:00-07:00',
                'timeZone': '(GMT+06:00) Bangladesh Standard Time'
            },
            'attendees': [
                {'email': 'tuman_ctg@yahoo.com'},
                {'email': 'rizwan@tigeritbd.com'},
                {'email': 'tuman.cse03@gmail.com'},
                {'email': 'shekhor.chanda@tigerit.com'}
            ]
        };

        var request = gapi.client.calendar.events.insert({
            'calendarId': 'primary',
            'resource': event
        });

        request.execute(function(event) {
            console.log('Event created: %s', event.data.htmlLink);
           // appendPre('Event created: ' + event.htmlLink);
        });
    }

</script>

<script async defer src="https://apis.google.com/js/api.js"
        onload="this.onload=function(){};handleClientLoad()"
        onreadystatechange="if (this.readyState === 'complete') this.onload()">
</script>
</body>
</html>
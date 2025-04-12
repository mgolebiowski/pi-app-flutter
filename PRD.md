# Product Requirements Document: Kraków Tram Departures Display App

**1. Introduction**

This document outlines the requirements for a read-only Flutter mobile application that displays real-time tram departure information for the "Czyżyny" stop in Kraków. The application will fetch data from an existing backend API and update the user interface automatically.

**2. Goals**

* Provide users with up-to-date tram departure information for the Czyżyny stop.
* Offer a clear and easy-to-understand display of estimated times of arrival (ETAs) and destinations.
* Visually highlight imminent departures.
* Indicate trams heading towards the city center.

**3. Target Audience**

* Passengers waiting for trams at the Czyżyny stop.
* Individuals planning their journeys from Czyżyny.

**4. Functional Requirements**

* **Data Fetching:** The app shall periodically fetch data from the existing backend endpoint `localhost:8080/stop` every 10 seconds.
* **Real-time Updates:** The UI shall automatically update with the latest data received from the backend.
* **Header Display:** The app shall display a static header with the text "Czyżyny".
* **Time and Date Display:** The app shall display the current time and date, updated in real-time. This information is not provided by the current backend endpoint and will need to be generated locally within the app.
* **Weather Display:** The app shall display the current weather information, including temperature and an icon representing the weather condition, as provided by the backend endpoint. The app will need to interpret the `weather.icon` value (referencing [https://openweathermap.org/weather-conditions](https://openweathermap.org/weather-conditions)).
* **Tram List Display:** The app shall display a list of upcoming tram departures, including:
    * **Line Number:** The number of the tram line.
    * **Direction:** The destination of the tram.
    * **ETA:** The estimated time of arrival, displayed in minutes. The app needs to extract the numerical value from the ETA string (e.g., "7 min" -> 7).
* **ETA Highlighting:** The ETA for a tram shall be displayed in red text when the remaining time is 5 minutes or less.
* **City Center Indicator:** If the `isTripToCityCenter` field in the backend response is `true`, a city icon (🏙️) shall be displayed next to the destination.

**5. Non-Functional Requirements**

* **Performance:** The app shall be responsive and update the UI smoothly upon receiving new data.
* **Reliability:** The app should handle network connectivity issues gracefully and attempt to reconnect to the backend.
* **Usability:** The information displayed should be clear, concise, and easy to read.
* **Maintainability:** The codebase should be well-structured and easy to maintain.

**6. Backend API Specification (Existing)**

* **Endpoint:** `localhost:8080/stop`
* **Method:** `GET`
* **Response Format:** `JSON`
* **Response Data:** The JSON response contains the following information:
    ```json
    {
      "trams": [
        {
          "tripId": "string",
          "line": "string",
          "direction": "string",
          "eta": "string", // e.g., "7 min"
          "isTripToCityCenter": boolean
        }
      ],
      "weather": {
        "temperature": number, // in Celsius
        "icon": "string" // OpenWeatherMap icon code
      }
    }
    ```

**7. UI Design Considerations**

* Use clear and legible fonts.
* Employ a color scheme that provides good contrast.
* The city center icon should be easily recognizable.
* The weather icon should be appropriately displayed based on the `weather.icon` code.

**8. Technology Stack**

* **Frontend:** Flutter

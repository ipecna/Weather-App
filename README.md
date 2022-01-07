#  MVC Weather App

This is a simple weather app built on MVC (not massive though) 

The main screen has a search bar sending a query to OpenWeather API and displaying the city name, temperature (with different background colors for every range) and conditions image. Also there's a table view with a basic forecast for the next 5 days.
In certain conditions there are animations and particle effects, so play with different cities :)

Detail controller shows more information about the city and its weather condition for the current day. To open detail view click the conditions icon.

Data is persisted via CoreData, network layer is built with Codable, interface is completely coded with no storyboard, so there are no third-party dependencies which I am proud of.

I am currently improving and finishing the project, however the basic functionality should be available.


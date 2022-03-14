# wasteagram

Wasteagram is a mobile app that enables coffee shop employees to document daily food waste in the form of "posts" consisting of a photo, number of leftover items, the current date, and the location of the device when the post is created. This application also lists all previous posts so that the owner and employees can keep track of how many food items are going to waste and adjust pastry orders accordingly.

This app uses several flutter packages.
1) location package to request permission for location services and obtains the latitude and longitude of the device to store as a "post".
2) image_picker package to allow the user to select a photo from their gallery
3) cloud_firestore & firebase_storage package to store data in Firestore and images in Firebase Cloud Storage, respectively 
4) sentry_flutter package to integrate crash reporting and record application crashes
5) test package for unit test suite
6) integration_test package for integration test of a UX feature
7) intl package to convert DateTime to be used as the photo's name 

App demonstration can be seen here: https://www.youtube.com/watch?v=B1uo_NFnVys

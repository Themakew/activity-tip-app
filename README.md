# ActivityTip app

ActivityTip is a simple app to sample some basic features, such as: API integration, ViewCode, collectionView and MVVM-C with RxSwift.

## Functionalities
✔️ A random activity is displayed for the user.

✔️ The user can request another random activity.

✔️ The user can see the activity details and status his status, such as: progress status and time spend doing the exercise.

## Technologies and tools used

- Swift: program language
- RxSwift: for biding the data using the MVVM-C
- UIKit: for building screen programatically
- XCoordinator: for organize the app navigation
- CoreData: save the activity info
- AlamofireNetworkActivityLogger: for display the requests log in xcode console

## Architecture used

Architecture used was MVVM-C, with some elements of Clean Architecture. Strong reference used: <a href="https://github.com/kudoleh/iOS-Clean-Architecture-MVVM">Repo.</a></p> 

## API used for integration

API integration with this app was <a href="https://github.com/kudoleh/iOS-Clean-Architecture-MVVM">BoredAPI.</a></p>
Because this API has a habit of returning response status code 200 for actually error responses, a workaround in the network layer was required.

## How to run the project?

It is quite straightforward; it simply opens the ".xcodeproj" file, waits for SPM to install the dependencies, and then runs. 

## TODO (Future Work)

- List the user's saved activities, where he can see all his saved activities and open the details of the selected activity.

---
<p align="center">Made by Ruyther Costa | Find me on <a href="https://www.linkedin.com/in/ruyther">LinkedIn</a></p>

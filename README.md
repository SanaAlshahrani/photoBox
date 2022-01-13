# photoBox

## Description
Swift App that serves photographer and customers. Display onboarding pages that show the user information about the application. In addtion, Enable user to book photo session and take photographing courses. Also, Photographers can display their ads in the ad space. Show videos related to teaching photograping to the user. The ability to display photographic locations close to the user with prices. User and photographer can edit the profile, change the language, view saved photos, comments and conversations. Also, enable user to view photos with (like, comment and share properties).  In addition, it enable user to take photo from camera and deploy it in the app.

## Users Stories/Photographer:
(Onboarding pages):
(user):
- as a user I want to know about the application through the onboarding pages.

(Cateogry page):
(user):
- as a user, I want to choose the category that I prefer to follow so that I can return to it.

(Login/Register):
(user):
- as a user I want to register so that I can access the system.
- as a user I want to login so that I can use Application.

(Photographer):
- as a Photographer I want to register so that I can access the system.
- as a Photographer I want to login so that I can use Application.

(Bublic page):
(user):
- as a user I can see images that have been displayed in the public page so that I select images that I liked.
- as a user I want to share my photos on a page so that other users can view and comment,like and share on them.

(Photographer):
- as a Photographer I want to share my photos on a page so that other users can view and comment,like and share on them.

(Ads space): 
(Photographer):
- as a photographer I want to add an ads so that users can know the latest offers.

(Details page):
(user):
- as a user I can see the image details including image description and the name  of photographer.
- as a user I can press like button so that the image will shown in the favorite page.
- as a user I can write a comment so that I can express my opinion on that image.
- as a user I can press share button so that I can share the image with my friend in various Application.

(Photographer):
- as a Photographer I can see the image details including image description and the name  of photographer.
- as a Photographer I can press like button so that the image will shown in the favorite page.
- as a Photographer I can write a comment so that I can express my opinion on that image.
- as a Photographer I can press share button so that I can share the image with my friend in various Application.
 
 (Chat page):
 (user):
- as a user I want to communicate with photographers so that I can book an appointment through direct messages.
- as a user I want to go directly to the photographer's Instagram page so that I can see his private file there.

(Photographer):
- as a photographer I want to facilitate communication with the user via direct message so that the date of the shooting is confirm between them.

(Places & Videos page):
(user):
- as a user I want to learn photography through videos so that I reach my goal of photography.
- as a user I want to know the places of photography near me so that I can communicate with them directly.

(Photographer):
- as a photographer I want to share educational videos of photography so that the user can learn from them.

(Camera page):
(user):
- as a user I can take photos and videos so that I can display on the public page with comment.

(Photographer):
- as a Photographer I can take photos and videos so that I can display on the public page with comment.
 
(Profile: Edit profile/Change language/Application mode/Favorite images/Commented images/Chats/Log out):
(user):
- as a user I want to display my information in profile page.
- as a user I want to add picture so that the user can distinct me.
- as a user I want to type my name so that the people can know me.
- as a user I want to change the language so that I can use the application in two different languages.
- as a user I want to change the mode of the application so that I can use the application with two different mode.
- as a user I can display the list of images that I liked so that I can refer to its later.
- as a user I can display the list of comments so that I commented so that I can refer to its later.
- as a user I can display the list of chats so that I can refer to its later.
- as a user I can log out from the application.
 
(Photographer):
- as a Photographer I want to insert instgram link so that the people can know/communicate with me .
- as a Photographer I want to display my information in profile page .
- as a Photographer I want to add picture so that the people can know me .
- as a Photographer I want to type name so that the people can know me .
- as a Photographer I want to change the language so that I can use the application in two different languages.
- as a Photographer I want to change the mode of the application so that I can use the application with two different mode.
- as a Photographer I can display the list of images that I liked so that I can refer to its later.
- as a Photographer I can display the list of comments so that I commented so that I can refer to its later.
- as a Photographer I can display the list of chats so that I can refer to its later.
- as a Photographer I can log out from the application.
 

 
| Component         |    Permissions    | Behavior   | 
| :---              |     ---           |   :---     |
| OnboardVC         |      public       | Frist page |
| CategoryVC        |      public       | Allows users and photographers to choose the categories they prefer|
| StartVC           |      public       | Allows users to register and login to the app|
| ImagesCV          | user/Photographer | Allows users and photographers to display their photos and add their ads|
| DetailsTV         | user/Photographer | Allows users and photographers to add comment, like and share photos|
| UsersVC           | user/Photographer | Allows users and photographers to instant messaging and enter the photographer's page|
| PlacesVideosVC    | user/Photographer | Allows users to take advantage of photography instructional videos and learn about shooting locations near them|
| CameraVC          | user/Photographer | Allows users and photographers to take pictures and publish them with a comment|
| ProfileVC         | user/Photographer | Allows users and photographers to edit their profiles, change the language, change the appearance of the app, see favorite photos, comments, and saved conversations|


## Components:
* OnboardVC. 
* CategoryVC.
* StartVC.
* SignupVC.
* LoginVC.
* TabBar.
* ImagesCV.
* DetailsTV.
* ImagesFavoritCV.
* UsersVC.
* ChatViewController.
* DetialsVC.
* PlacesVideosVC.
* ProfileVC.
* CameraVC.

## Service
##### Auth Service
auth.login(user)
auth.signup(user)
auth.logout()

## Models
* Model. 
* User.
* Message.
* ChatRoom.
* Recent.

## Slides
Repository link: https://github.com/SanaAlshahrani/photoBox

presentation link: https://docs.google.com/presentation/d/1NP44Mlv-D6OQKNl9h-g7zYecziX0rPYSSS7zW2uEXoY/edit?usp=sharing

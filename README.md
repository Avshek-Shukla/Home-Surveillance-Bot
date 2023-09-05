# Home-Surveillance-Bot
## Introduction
Surveillance and Monitoring Bot, in general, is a hardware and software-based project which is specifically designed for observing different mobile activities for home security. The objective of this project is to enhance home security by developing a surveillance system using the ESP32-CAM module and a mobile application.
The ESP32-CAM module serves as the core hardware component, providing the ability to capture images and stream live video. It leverages the Wi-Fi capabilities of the ESP32 to connect to a local network, allowing for remote access and control. To interact with the surveillance system, a mobile application is developed using flutter. The application serves as a centralized control hub, enabling users to remotely monitor the system, view live video feeds. The whole system is capable to move in different directions using motors and wheels which are also controlled by application using remote access capability of ESP32.
To protect the system from unauthorized access, authentication system is implemented within app. This ensures the security and privacy of user.

## Methodology
Our main focus for this project is to provide users with an environment where they can know about the activity going around the bot. For this, we dedicated our effort to a case study of the surveillance system and its implementation. We will be using a ESP cam32 module for video footage and control. We will be using a flutter programming to design user interface application.

###  System Block Diagram
The general concept of execution is that the user gives the commands through application and the hardware fetches the command through webserver using internet and processes it and executes it.
![image](https://github.com/KingMaker960/Home-Surveillance-Bot/assets/85979695/0c38c8b3-7cb5-4b84-8a18-89552de5af2b)

###  Activity Diagram of Hardware System
Activity diagrams show the flow of sequential activity taking place in that system. Let us see the activity diagram as follow:
![image](https://github.com/KingMaker960/Home-Surveillance-Bot/assets/85979695/2c4327c3-2f84-4a30-af34-13b7f0406167)

### Use Case Diagram for Application
![image](https://github.com/KingMaker960/Home-Surveillance-Bot/assets/85979695/c451c06d-0e7d-4049-8eaf-fb188c2e819f)


## OUTPUT AND ANALYSIS
![image](https://github.com/KingMaker960/Home-Surveillance-Bot/assets/85979695/9747b742-4cf7-4cbb-a85b-c26d1b8906b1)
The above figure shows the UI of our application we have made in flutter. The Connect button in the center is used to connect the camera. The flash icon in the top left corner is used to turn on/off the camera flash. Similarly, the up and down icon in left controller pad and left and right icon in right controller pad are used to move bot forward, backward, turn left and turn right respectively. Similarly, the left and right icon in left controller pad and up and down icon in right controller pad is used to rotate camera left, right, up and down respectively.

# Aptitude Test

## 1.	Build a classification model ##

The image classification algorithm uses PyTorch to define a neural network to process three-channel images. Use the torchvision package to preprocess image files. The training set and test set are classified in the traditional way 7:3, loaded and normalized by torchvision. Define the convolutional neural network and loss function based on the image-processed data, and train and test the network on this basis.

Training and testing use the GPU instead of the CPU to run faster. However, limited by my GPU and hard disk capacity, the preprocessed image size is limited to 512*512 to ensure that the model training after image processing can be allocated within the available video memory.

By testing the trained model, the current highest test result is an overall accuracy rate of 78%. The average accuracy was between 73-78%, with 60-90% accuracy for all three different furniture types. The trained model has not been uploaded to Github, and the upload failed due to the limitation of github on the file size. Will be saved in Google Drive.

Classification models require the following environment to run:

     Python: 3.7.2 (Pytorch's quick download command does not support later versions, and the vision package does not exist in version 3.7.0)
     pip3: included in python3
     numpy: 1.21.6
     Pillow: 9.4.0
     GPUtil: 1.4.0 (optional, for testing GPUs)
     CUDA: 11.6
     Pytorch: 1.13.1
     Nvidia Drive: base on your device

Commands to quickly download pytorch and the corresponding CUDA and other packages:

      pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

Due to time factors, model training and model testing are written in the same script instead of separate files. According to the documentation of Pytorch itself, the model can be loaded independently in the following ways:

      model = TheModelClass(*args, **kwargs)
      model.load_state_dict(torch.load(PATH))
      model.eval()

The class of the neural network needs to be loaded additionally. Fully saved models have some issues and cannot be used correctly.

## 2.	Build an API 

The programs of the API are provided only as design ideas and not as complete programs for the following reasons:

1. The design and writing of the API takes longer to ensure that the API will not have bugs and bugs. A simple API written in a short period of time cannot guarantee that all aspects are considered.

2. For security reasons: availability and confidentiality. APIs require a certain security design to prevent flood attacks or data leakage due to API vulnerabilities. Insecure APIs can cost organizations significant damage and even involve legal disputes.

### The following is my design concept for the API

**Front End**

The front end needs input in two directions:
1. The user inputs images and labels, the front end sends the images to the API, and then the API makes predictions and returns the prediction results. The front end compares the prediction results and returns the prediction results to the user
2. The user inputs the image, repeats the above steps, and returns the test result to the user without any comparison.

The above method can have two different input interfaces, or two identical input interfaces, but there is an optional text input box. The front end judges the optional text box to return different results.

In addition, the front end needs to have two optional image upload methods: the first is to upload files by users, and the second is to use image urls to read.

The following is the html code of the uploaded file

      <form action="/action_page.php"
         enctype="multipart/form-data">
          
         <label for="myfile">Select a file:</label>
         <input type="file" id="myfile" name="myfile" />
         <br /><br />
         <input type="submit" />
     </form>

The following is the func code for reading the URL:

```
function readURL(input) {
   if (input. files && input. files[0]) {
     var reader = new FileReader();

     reader.onload = function(e) {
       $('#blah').attr('src', e.target.result);
     }

     reader.readAsDataURL(input.files[0]);
      }
      }
     $("#imgInp").change(function() {
      readURL(this);
    });
```

**Back-end Request handle**

The request processing module and the backend prediction model are two separate modules. The request processing module accepts the request containing the file, and then preprocesses the request. It is worth mentioning that although the file format uploaded by users can be guaranteed at the front end to prevent malicious file attacks. However, some known attack methods can bypass the front end and directly transfer files to the API. In order to keep the model safe, we need to preprocess the file.

File preprocessing includes whether the file format is correct, and the actual commercial API also needs to include a firewall to analyze the requested package. Any malformed files will be discarded directly in the request handler, and an error response will be returned.

**Back-end image pre-processing**

The API will only accept image files, as I said above, data other than images is processed directly by the front end. After complete image preprocessing, the request processing module sends the image file to the data processing module, and the data processing module processes the basic data of the image. This step of processing is to enable the image to be read by the prediction model. In this step, the data processing module will set an error handle to capture the error information, and directly return the error information to the request processing module. The data processing module also needs to have a queue function to prevent too much data from being sent to the model.

**Back-end Result processing**

The preprocessed data is sent to the background image classification model. The model sends simple results to the result processing module. The result processing module translates the prediction results of the model into more popular text. For example, for the sake of integrity, the model will only return a digital code, and the result processing module translates it into text and sends it to the request processing module. The request processing module sends the text reply to the front end to display to the user. The reason for the existence of this module is to reduce the pressure on the model, and to prevent the model from communicating directly with the request processing module.

**Back-end quest tracking**

In this process, requests and data are distinguished by independent uids, and different requests contain different uids, and at the backend, uids will be destroyed after the mission is completed and will not be stored in any way.

## 3.	Create a Docker image 

The Docker Image file is too large to be uploaded to Github, please follow the link in the Readme to get it.

The docker image can be successfully created according to the instructions in the Dockerfile. But there is a connection error in this image, and it cannot connect and download pytorch correctly. Due to time and disk space I can't fully debug all errors.

Image uses Python:3-windowsservercore to run pip and other commands. This base may be one of the sources of errors. Then download numpy, Pillow and GPUtil according to the requirement content. CUDA, pytorch vision is downloaded directly through PyTorch, and this instruction may also be the source of the problem.

One of the possible reasons for the problem with the Image command is that the type of the container is Linux. Part of the problem can be solved by changing the type of the Container to Windows. Since I don't have access to a suitable Linux device at this stage, I can only use a Windows system for this test at the moment.

## 4.	Implement CI/CD 



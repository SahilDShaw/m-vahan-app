
# m-Vahan App

This project was undertaken as part of the Flutter app development internship at the **National Informatics Centre Headquarters** in New Delhi.\
The primary objective of the application is to facilitate the scanning of QR codes containing encrypted information about a driver or vehicle. Subsequently, the app generates digitally signed PDFs, which can be uploaded to a simulated Firebase backend as base64 strings. These uploaded PDFs are retrievable and can be viewed within the application at a later time.


## Documentation

### Getting Started
- Install **Flutter 3.16.4**. Follow [this](https://docs.flutter.dev/get-started/install) link for step-by-step directions. Select Mobile as the first type of app. 
- Install an Android emulator with API level 33 or higher.
- Clone or download the .zip file of this repository and extract the code into the desired directory.
- Go to the project directory
- Install dependencies

```bash
flutter pub get
```

### Important Notice 
Since the app was built only for test mode, the Firebase database linked to the app needs to be configured for the new emulator. But the sole access to the Firebase project lies with the owner of this repository **(Sahil Shah)**. Hence, it is recommended to consider the following changes to the code:
- Create your own Firebase project, or
- Integrate APIs for your own backend
Both the methods are explained in detail below.

#### Create your own Firebase project
1) Delete the ```firebase_options.dart``` file from the ```lib``` folder.
2) Create your own Firebase Flutter project from your Firebase [console](https://console.firebase.google.com/).
3) Create a Firestore database, which has a collection named **PDFs** which further can store documents with fields 
- **Name** (String), 
- **base64String** (String), and
- **size** (String).
The database should look like this.\
![Firestore database](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/firebase-database.png?raw=true)\
4) Configure the project by following the steps mentioned in [this](https://www.youtube.com/watch?v=FkFvQ0SaT1I) video.

#### Integrate APIs for your own backend
Before integrating your own APIs for fetching or storing data from the database, follow these steps:
1) Open the project in VS Code.
2) Delete ```firebase.service.dart``` file from the ```lib/services``` folder.
3) Remove the follow code from the providers list in ```main.dart``` in ```lib``` folder
```
ChangeNotifierProvider<FirebaseProvider>(
    create: (BuildContext ctx) => FirebaseProvider(),
),
```
4) Remove all the references to the ```FirebaseProvider``` class from all the dart files.

Now, you can integrate appropriate APIs in the places where FirebaseProvider was used.

### Run App
Once all the above mentioned steps are done, open the project in VS Code and start debugging the project by pressing the **```f5```** key or running the following command in the cmd opened in the project directory.
```bash
flutter run
```
If you are facing some errors, kindly follow the steps mentioned again. If the problem persists, kindly take the help of ```StackExchange```.

### Navigating Through the App
After the app builds successfully, a ```Sign In screen``` appears in the emulator as shown.

#### Sign In Screen
![Sign In Screen](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/sign-in-screen.jpg?raw=true)\
The ```Sign In Screen``` consists of 
- **App logo**, 
- **3 text-fields with validation** (User Id, Password, and Captcha), 
- **Captcha** (dynamically generated mathematical expression with a gradient colored background), 
- **a ```Sign In``` button**, 
- **Android device ID**, and 
- **```Click here``` button** (for user registration).
This screen also contains a floating navigation button which takes the user to the ```List screen```. This button was added because there was no access available to the authentication APIs during the development of the project and hence the APIs were **NOT** integrated.

#### List Screen
![List Screen](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/list-screen.jpg?raw=true)\
The ```List Screen``` consists of 
- **App logo**, 
- **Menu button**, and
- **List of Actions that can be performed** (```Scan QR```, ```Download PDF```)
The List items navigate to their respective screens.

#### QR Scanner Screen
![QR Scanner Screen](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/qr-scanner-screen.jpg?raw=true)\
The ```QR Scanner Screen``` consists of
- **QR Scanner**,
- **```Scan a Valid Code``` text**
The QR Scanner scans for a ```Valid QR``` and automatically navigates to the ```Generate PDF Screen```.

#### Generate PDF Screen
![Generate PDF Screen](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/generate-pdf-screen.jpg?raw=true)\
The ```Generate PDF Screen``` consists of
- **Driver/Vehicle Details**,
- **```Generate PDF``` button**,
- **```Upload PDF``` button**
The ```Generate PDF``` button generates a digitally signed PDF with Driver/Vehicle Details with NIC logo, a dummy headline and pargraph, information about the digital signature and footer containing the page number. The PDF generated is saved locally in app cache and a preview is displayed to the user.\
The ```Upload PDF``` button uploads the PDF as a ```base64String``` to the ```FireStore``` database. A document containing ```name ('${DLNo of the driver/VehicleNo of the vehicle}.pdf')```, the ```base64String``` and the ```size``` of the pdf is created in ```PDFs``` collection for each PDF.\
After the pdf is successfully uploaded, a ```SnackBar``` displaying the ```document id``` of the PDF is shown.

#### Download PDF Screen
![Download PDF Screen](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/download-pdf-screen.jpg?raw=true)\
The ```Download PDF Screen``` displays a list of all the documents uploaded to the database with option to download and display the each PDF.
### What does ```Valid QR``` Mean?
The app handles 2 types of data models - Driver details and Vehicle Details. The data in each model can be represented as key-value pairs. Examples are as follows:\
Driver Details Model
```json
{
    "qr_type": "driver",
    "data": {
        "dl_no": "12345678",
        "name": "Sahil Shah",
        "address": "NIC, CGO Complex, JLN Stadium, Delhi",
        "dob": "20020922"
    }
}
```
Vehicle Details Model
```json
{
    "qr_type": "vehicle",
    "data": {
        "vehicle_no": "DL12ABCD3456",
        "manufacturer": "Tata Motors",
        "model": "Altroz",
        "variant": "XZ",
        "age": 5,
        "kms_driven": 30000,
        "reg_city": "Delhi"
    }
}
```
These data models can be changed according to your requirements. To do so, modify ```driver_data.model.dart``` and ```vehicle_data.model.dart``` in ```lib/models``` folder. You  can also add other models to your app but then you would have to handle the information accordingly.\
Now, once an instance is found, say a Driver, we create a ```String``` containing all the key-value pairs for that instance.\
The string is then encrypted using ```Fernet Encryption```. The key required for the encryption is set as:
```
HelloWorldHelloWorldHelloWorldHe
```
This is a ```32-character``` string which is hidden in app using ```Native C++ Code```.\
You can change this key as you desire in the ```api_util.cpp``` file in ```ios/Classes``` folder under the ```get_fernet_key()``` function.\
The encrypted strings for the above mentioned example data models is as follows:\
Driver Details Encrypted String
```
gAAAAABlk6YV0xnvakc9a+8n/eos31TlV9iuVgwf8+H4bURQC/IXGv2qc/l+ShKFGgNNpTTjAATDTu8rDISJxaZmLFttw3VYHjJpZimo1xd9YgDPrth+12C1Lq7w5nk0uPimqqmugubuqV+Eq+w2H7OyQVEAmo3GtSVYrvpila54BRYDHELuMibdPFV+Pn9Ylp9VkeuImx7gSxxKJ+K9EPE029DMZY/U8P1GSN9YwYAU0tMejSpwpSCAnjzUzQ0c1rg8qIV+AWO/
```
Vehicle Details Encrypted String
```
gAAAAABlk6cnFffpoZ/vOJTV5VoUspNmGLW3VoTfcTS15TbDD1edsY4HwsOcCC0Yxc86UrUckXrTqkYNoY/I235H5RRRZ2lYEdRnFrdCN1OrCjN7K7rAfSjHsTY/reXwc3gHe/gDXA6e7EN8hsotKTOrhFbq4VOdC1rCqPhL/7WKjJ11ijaxumQjLIvatDTWsHDEWksG+xHJtbkrxZhZ15xzwusRLhVlgyKGslaeh0nfYPrey7+df4gCJszTdAhTK4mZ/0NX53ej/9MW33yswafkZou1nwwgy9qhfMmONMyDvuI41oyzMSc=
```
After the encryption, the encrypted ```String``` found so far converted into a ```QR Code using``` a standard ```QR Code Generator```.\
This QR generated so far is considered as a ```Valid QR``` for this app. The Valid QRs for the above mentioned example data models is as follows:\
Driver Details Valid QR\
![Driver Details Valid QR](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/valid-qr-driver-details.png?raw=true)\
Vehicle Details Valid QR\
![Vehicle Details Valid QR](https://github.com/SahilDShaw/m-vahan-app/blob/main/media/valid-qr-vehicle-details.png?raw=true)
### Modifying the Digital Signature

All the PDFs generated on the app have a digital signature.\
A digital signature is produced using a ```digital certificate``` issued by an authority like NIC. The certificate is of ```.pfx``` format.\
For this project, a dummy certificate (```certificate.pfx```) was created using ```OpenSSL```. It is located in the ```assets/certificates``` folder.

#### **Create your own digital certificate using OpenSSL**

In order to create a certificate using we need OpenSSL installed. In most Mac and Windows computers OpenSSL is already present. You can access its manual documentaion [here](https://man.openbsd.org/openssl.1). Check your OpenSSL version by running the following command in the command prompt:
```bash
openssl version
```

Now, we start creating our certificate.\
**Generate CA'private key and certificate**
```bash
openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem
```
This command is used to create and process certificate signing request.\
The ```-x509``` option is used to tell openssl to output a self-signed certificate instead of a certificate request.\
The ```-newkey rsa:4096``` option basically tells openssl to create both a new RSA private key (4096-bit) and its certificate request at the same time. As we’re using this together with ```-x509``` option, it will output a certificate instead of a certificate request.\
The next option is ```-days 365```, which specifies the number of days that the certificate is valid for.\
Then we use the ```-keyout``` option to tell openssl to write the created private key to ```ca-key.pem``` file.\
And finally the ```-out``` option to tell it to write the certificate to ```ca-cert.pem``` file.\
When we run this command, openssl will start generating the private key.\
Once the key is generated, we will be asked to provide a ```pass phrase```, which will be used to encrypt the private key before writing it to the PEM file.\
Next, openssl will ask us for some identity information to generate the certificate:
- The country code
- The state or province name
- The organisation name
- The unit name
- The common name (or domain name)
- The email address

Update the values for these fields in the ```constants.dart``` file in ```lib/shared``` folder.

**Creating PFX using OpenSSL**
```bash
openssl pkcs12 -export -in ca-cert.pem -inkey ca-key.pem -out certificate.pfx
```
Here, you will be prompted to enter a password protecting the certificate.\
For this project, the password was chosen as:
```
password@123
```
If you choose to set a different password(recommended), updated the password in ```api_util.cpp``` in ```ios/Classes``` folder under the ```get_certificate_password()``` function.\
After the desired password is entered, a ```certificate.pfx``` file is created in the directory (where you are located). Replace this file with the ```certificate.pfx``` file in ```assets/certificates``` folder.\
Now, you are good to go.
## Authors

- [Sahil Shah](https://github.com/SahilDShaw)


## License

[MIT](https://github.com/SahilDShaw/m-vahan-app/blob/main/LICENSE) © Sahil Shah
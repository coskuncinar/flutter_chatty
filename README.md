# Flutter chatty

## Project package

*  firebase_core
*  firebase_auth
*  get_it
*  google_sign_in
*  flutter_facebook_auth
*  cloud_firestore
*  firebase_storage
*  http
*  timeago
*  flutter_bloc
*  equatable
*  uuid
*  image_picker
*  firebase_messaging
*  path_provider
*  flutter_local_notifications
*  google_mobile_ads

## Firebase roles
<pre><code>

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if
          request.time < timestamp.date(2022, 5, 30);
    }
    
    match /clientUsers/{userId}{
    	allow read : if request.aut != null;
      allow write: if request.auth.uid == userId;
    }
    match /tokes/{userId}{
    	allow read : if request.aut != null;
      allow write: if request.auth.uid == userId;    
    }
    match /server/{userId}{
    	allow read : if request.auth.uid == userId;
      allow write: if request.auth.uid == userId;    
    }  
    match /chats/{chatId}{
    	allow read : if resource.data.chatOwnerId == chatId;
      allow write: if (request.auth.uid  == request.resource.data.chatOwnerId || request.auth.uid == request.resource.data.chatUserId );    

			match /messages/{messageId} {
      	allow read : if  resource.data.messageOwnerId == request.auth.uid;
      	allow write: if (request.auth.uid == request.resource.data.from || request.auth.uid == request.resource.data.to);  
      }
    }      
  }
}
</code></pre>



<img src="https://github.com/coskuncinar/flutter_chatty/blob/main/screenshots/FlutterChatty_preview.gif?raw=true"  />

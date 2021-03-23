# Documentation for Back End Api

## 1. To Check if an SID is valid for Sign Up

  href - ../signup/<SID>  -- [GET]
  body - null
  
  returns 
  {
    "code" : code 
   }
  
  If SID does not exist, code =  401
  If SID exists, but is alreaedy in SignUp Table, code =  402
  If SID is valid, code =  200
  
  eg 
  http://127.0.0.1:5000/signup/19193096 -- [GET]
  
  returns - 
  {
    "code" : 200
  }
  if sid is valid for sign up
  

## 2. To Sign up 
  
  href - ../signup  -- [POST]
  
  body - 
  {
    "SID" : sid,
    "password" : "pwd"
  }
  
  
  returns 
  {
    "code" : 200,
    "auth" : x
  }
  
  x depends on the auth level of the user, provided by the backend database
  auth 0 -> Student
  auth 1 -> CR
  auth 2 -> Secretary/Joint Secretary of Club/Society
  
  The password is hashed before storing in the database
  
  eg
  http://127.0.0.1:5000/signup -- [POST]
  body - 
  {
    "SID" : 19103096,
    "password" : "testpwd"
  }
  
  returns - 
  {
    "code" : 200,
    "auth" : 1
  }
  
  
## 3. To Get All Sign Up

  href - ../signup -- [GET]
  body - null
  
  returns - JSON key value pairs of all students in sign up table
  
  eg 
  
  href - ../signup  -- [POST]
  
  body - 
  {
    "SID" : 19103001,
    "password" : "dfasjdfasdfvasdfviuasbdfgfvb2343892"
  }
  {
    "SID" : 19103096,
    "password" : "fajsdfasidfuafwoberfvijbasdfv"
  }
  {
    "SID" : 19103099,
    "password" : "sadfawsfiuwebrgiuyedbsdfgasfaergar"
  }
  
  
## 4. To Change/Update Password

    href - ../signup/<SID> -- [PUT]
    
    body - 
    {
      "SID" : sid,
      "password" : "newpassword"
    }
    
    returns - 
    
    {
      'code' : 200
    }
    
## 5. To Login 
  
    href - ../login -- [POST]
    body - 
    
    {
    "SID" : sid,
    "password" : "pwd"
    }
    
    returns - 
    i. If no such sign up exists
    {
      "code" : 403
    }
    
    ii. If sign up exists but password entered is wrong
    {
      "code" : 404
    }
    
    iii. 
    {
      "code" : 200,
      "auth" : x
    }
    x depending on the auth of the user.
    
## 6. To Delete From Sign Up
 
      href - ../signup/<SID> -- [DELETE]
      body - null
      
      returns - 
      {
        "code" : 200
      }
      for successful deletion
      
 ## 7. To Add In Auth
 
    href - ../auth -- [POST]
    body - 
    {
      "SID" : sid, 
      "auth" : x
    }
    x can be 1 or 2
    for x = 0, entry is not added in the Auth Table
    
    returns - 
    {
        "code" : 200
    }
    for successful insertion
    
    
 ## 8. To Update Auth 
    
    href - ../auth/<SID> -- [PUT]
    body - 
    {
      "SID" : sid, 
      "auth" : newAuth
    }
    newAuth can be 1 or 2
    for newAuth = 0, entry is not added in the Auth Table
    
    returns - 
    {
        "code" : 200
    }
    for successful updation
    
 ## 9. To Delete Auth
      
    href - ../auth/<SID> -- [DELETE]
    body - null
    
    returns - 
    {
        "code" : 200
    }
    for successful updation
 
    
  
    
     
    
  
  
  
  
  
  
  
  
  

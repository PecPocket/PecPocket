# Documentation for Back End Api

## 1. To Check if an SID is valid for Sign Up

    href - ../signup/<SID>  -- [GET]
    body - null

    returns 
    {
      "code" : x 
     }

    x -> 401 If SID does not exist
    x -> 402 If SID exists, but is alreaedy in SignUp Table
    x -> 200 If SID is valid, code 

    eg 
    http://127.0.0.1:5000/signup/19193096 -- [GET]

    returns - 
    {
      "code" : 200
    }
    If sid is valid for sign up
  

## 2. To Sign up 
  
    href - ../signup  -- [POST]

    body - 
    {
      "SID" : sid,
      "Password" : "pwd"
    }


    returns - 
    i. If entry with this sid already exists 
    {
      "code" : 402
    }
    
    ii. If Sign Up successful
    }
    {
      "code" : 200,
      "Auth" : x
    }
    x depends on the Auth level of the user, provided by the backend database
    Auth 0 -> Student
    Auth 1 -> CR
    Auth 2 -> Secretary/Joint Secretary of Club/Society

    The Password is hashed before storing in the database.

    eg
    http://127.0.0.1:5000/signup -- [POST]
    body - 
    {
      "SID" : 19103096,
      "Password" : "testpwd"
    }

    returns - 
    {
      "code" : 200,
      "Auth" : 1
    }

  
## 3. To Get All Sign Up

    href - ../signup -- [GET]
    body - null

    returns - JSON key value pairs of all students in sign up table

    eg 

    href - ../signup  -- [GET]

    body - 
    {
      "SID" : 19103001,
      "Password" : "dfasjdfasdfvasdfviuasbdfgfvb2343892"
    }
    {
      "SID" : 19103096,
      "Password" : "fajsdfasidfuafwoberfvijbasdfv"
    }
    {
      "SID" : 19103099,
      "Password" : "sadfawsfiuwebrgiuyedbsdfgasfaergar"
    }


## 4. To Change/Update Password

    href - ../signup/<SID> -- [PUT]
    
    body - 
    {
      "SID" : sid,
      "Password" : "newPassword"
    }
    
    returns - 

    {
      "code" : x
    }
    x -> 403 if sid does not exist in sign up table
    x -> 301 if new Password same as old Password
    x -> 200 if updation of Password is successful
    
    
## 5. To Login 
  
    href - ../login -- [POST]
    body - 
    {
    "SID" : sid,
    "Password" : "pwd"
    }
    pwd is the Password of the given sid
    
    returns - 
    i. If no such sign up exists
    {
      "code" : 403
    }
    
    ii. If sign up exists but Password entered is wrong
    {
      "code" : 404
    }
    
    iii. 
    {
      "code" : 200,
      "Auth" : x
    }
    x depending on the Auth of the user.
    
## 6. To Delete From Sign Up
 
    href - ../signup/<SID> -- [DELETE]
    body - null
    
    returns - 
    {
      "code" : x
    }
    x -> 200 for successful deletion
    x -> 403 if sign up does not exist
      
 ## 7. To Add In Auth
 
    href - ../Auth -- [POST]
    body - 
    {
      "SID" : sid, 
      "Auth" : x
    }
    x can be 1 or 2
    for x = 0, entry is not added in the Auth Table
    
    returns - 
    {
        "code" : x
    }
    x -> 200 if addition of Auth is successful
    x -> 405 if Auth of respective SID already exists
    
    
 ## 8. To Update Auth 
    
    href - ../Auth/<SID> -- [PUT]
    body - 
    {
      "SID" : sid, 
      "Auth" : newAuth
    }
    newAuth can be 1 or 2
    for newAuth = 0, entry is not added in the Auth Table
    
    returns - 
    {
        "code" : x
    }
    x -> 406 if Auth of given SID does not exist
    x -> 200 if Auth successfully updated
    
 ## 9. To Delete Auth
      
    href - ../Auth/<SID> -- [DELETE]
    body - null
    
    returns - 
    {
        "code" : x
    }
    x -> 406 if Auth of given SID does not exist
    x -> 200 if Auth successfully deleted
 
    
  
    
     
    
  
  
  
  
  
  
  
  
  

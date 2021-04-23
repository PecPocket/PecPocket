# Documentation for SignUp Back End Api

## 1. To Check if an SID is valid for Sign Up

    href - ../signup/<SID>  -- [GET]
    body - null

    returns 
    {
      "code" : x (int)
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
      "SID" : sid,  (int)
      "Password" : "pwd"  (string)
    }


    returns - 
    i. if the sid doesn't exist in the database
    {
      "code" : 401
    }
    ii. If entry with this sid already exists 
    {
      "code" : 402
    }
    
    iii. If Sign Up successful
    }
    {
      "code" : 200,
      "Auth" : x  (int)
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

  
  ## 3. To Change/Update Password

    href - ../signup/<SID> -- [PUT]
    
    body - 
    {
      "SID" : sid,  (int)
      "Password" : "newPassword"  (string)
    }
    
    returns - 

    {
      "code" : x  (int)
    }
    x -> 403 if sid does not exist in sign up table
    x -> 301 if new Password same as old Password
    x -> 200 if updation of Password is successful
    
    
## 4. To Login 
  
    href - ../login -- [POST]
    body - 
    {
    "SID" : sid,  (int)
    "Password" : "pwd"  (string)
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
      "Auth" : x  (int)
    }
    x depending on the Auth of the user.


## 5. Search query for subjects

    desc - to implement a search bar for subjects
    href - ../subject/search?query= -- [GET]
    body - null

    returns - 
    i. if no such subject exists
    {
        "code" : 408
    }

    ii. if the searched subjects exist
    JSON key value pairs of all those subjects from Sub Convertor Table

    eg

    href - ../subject/search/query?computer -- [GET]

    returns - 
    {
        "Subject_code" : "CSN101",
        "Subject" : "Computer Networks"
    },
    {
        "Subject_code" : "CSN104",
        "Subject" : "Computer Programming"
    }


## 6. Search query for clubs

    desc - to implement a search bar for clubs/socities
    href - ../club/search?query= -- [GET]
    body - null

    returns - 
    i. if no such club exists
    {
        "code" : 409
    }

    ii. if the searched clubs exist
    JSON key value pairs of all those club from Club Convertor Table

    eg

    href - ../club/search?query= -- [GET]

    returns - 
    {
        "Club_code" : "04",
        "Club" : "Projection and Design Club"
    },
    {
        "Club_code" : "08",
        "Club" : "Punjab Editorial Board"
    }

## 7. Add clubs to the Clubs Table during signup

    desc - converts the clubs list to a string to add to the Clubs Table
    href - ../signupclub -- [POST]
    body - 
    {
        "SID" : "sid",  (int)
        "Clubs" : ['club', 'codes', 'as', 'a', 'list']   (list of strings)
    }

    returns - 
    i. if the SID hasnt' signed up
    {
      "code" : 403
    }

    ii. if clubs were successfully added
    {
        "code" : 200
    }

    eg 

    href - ../signupclub
    body -
    {

        "SID" : 19103096,
        "Clubs" :["01", "02", "03"]
    }


## 8. Delete Account 

    desc - deletes account from tables -- SignUp, Authorization(if there), Clubs, Personal
    href - ../delete/<SID> -- [DELETE]
    body - null

    returns - 
    i. if user not in signup
    {
        "code" : 403
    }

    ii. if user in sign up
    {
        "code" : 200
    }



# Documentation for Clubs and Instagram Back End Api

## 1. To Get the List Of Clubs for an SID

    href - ../club/<SID>  -- [GET]
    body - null

    returns -

    i.
    {
      "code" : x (int)
     }

    x -> 404 If Student not in SignUp
    x -> 407 If Student does not have any club

    ii. 
    {
        "clubs" : ["list", "of", "club", "names"]   (lsit of strings)
    }

    eg 
    http://127.0.0.1:5000/signup/19193096 -- [GET]

    returns - 
    {
      "code" : 404
    }
    If student not signed up

    http://127.0.0.1:5000/signup/19193098 -- [GET]

    returns -
    {
        "clubs" : ["SAASC", "APC"]
    }
  

## 2. To Update Clubs for an SID

    href - ../club/<SID> -- [PUT]
    
    body - 
    {
      "SID" : sid,  (int)
      "Club_codes" : ["list", "of", "club", "codes"]    (list of strings)
    }
    
    returns - 

    {
      "code" : x  (int)
    }
    x -> 404 if sid does not exist in sign up table
    x -> 200 if updation of Clubs is successful



## 3. To Add/Update instagram handle 

    href - ../insta/<SID> -- [PUT]
    
    body - 
    {
      "SID" : sid,  (int)
      "Insta" : "handle"   string
    }
    
    returns - 

    {
      "code" : x  (int)
    }
    x -> 404 if sid does not exist in sign up table
    x -> 200 if creation/updating of insta handle is successful



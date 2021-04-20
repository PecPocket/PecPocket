# Documentation for Notification Lists Back End Api

## 1. To Get list of students in a Class of a CR

    href - ../cr/<SID>  -- [GET]
    body - null

    returns - 

    i.
    {
      "code" : 404
    }
    if SID of CR does not exist in Sign Up

    ii. 

    {
        "Students" : [List, of , sids]      (List of int)
    }
    Returns the list of SIDS of students in CR's class


    eg 
    http://127.0.0.1:5000/cr/19193098 -- [GET]

    returns - 
    {
      "Students" : [19103096,19103109]
    }
    
## 2. To Get list of students in a Club

    href - ../club/<Club_code>  -- [GET]
    body - null

    returns - 

    i.
    {
      "code" : x (int)
    }
     x -> 404 if club code does not exist
     x -> 403 if club has no students

    ii. 

    {
        "Students" : [List, of , sids]      (List of int)
    }
    Returns the list of SIDS of students in a Club


    eg 
    http://127.0.0.1:5000/club/01 -- [GET]

    returns - 
    {
      "Students" : [19103096,19103109]
    }
    
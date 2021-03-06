# Documentation for Clubs and Instagram Back End Api

## 1. To Get the List Of Clubs for an SID

    href - ../club/<SID>  -- [GET]
    body - null

    returns -

    i.
    {
      "code" : x (int)
     }

    x -> 403 If Student not in SignUp
    x -> 407 If Student does not have any club

    ii. 
    {
        "clubs" : ["list", "of", "club", "names"]   (list of strings)
    }

    eg 
    http://127.0.0.1:5000/signup/19193096 -- [GET]

    returns - 
    i. If student not signed up
    {
      "code" : 403
    }
    

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
      "Club_codes" : "010203"    (string with multiple codes appended together) - club_codes
    }
    
    returns - 

    {
      "code" : x  (int)
    }
    x -> 403 if sid does not exist in sign up table
    x -> 501 if the student currently has no clubs to update 
         (make  a POST request instead)
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


## 4. View Profile

    href - ../viewprofile/<SID> -- [GET]
    body - null

    returns - 
    i. if not in Personal database i.e. hasn't signed up 
    {
      'code':404
    }

    ii. if the SID is present- successful
    {
      "Name": person.Name, (string)
        "SID": person.SID,   (int)
        "Branch":person.Branch,     (string)
        "Year": person.Year,    (int)
        "Semester": person.Semester,    (int) 
        "Clubs": club_list  (list of strings of names of clubs)
        "Insta" : insta_handle, (string)
        "Avatar" : avatar_name (string)
    }

    eg
    http://127.0.0.1:5000/viewprofile/19103109 -- [GET]

    returns - 
    {
      "Name": "Isha Garg"
      "SID": 19103109
      "Branch": "Computer Science Engineering"
      "Year": 2
      "Semester": 4
      "Clubs": ["English Editorial Board", "PDC"],
      "Insta" : "-",
      "Avatar" : "bleh"
    }

## 5. Add/Update Avatar

    href - ../avatar -- [PUT]
    body - 
    {
      "SID" : sid, (int)
      "Avatar" : avatar_name (string)
    }

    returns - 
   {
      'code' : x
    }
    i. not signed up -> 404
    ii. successful addition -> 200


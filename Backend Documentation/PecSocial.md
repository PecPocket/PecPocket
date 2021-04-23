# Documentation For PecSocial Back End Api

## PecSocial

    href - ../social?query=  -- [GET]
    body - null

    returns - 

    i. if no search for given word
    {
      "code" : 404
    }

    ii. for a successful search
    {
        "Name": person.Name, (string)
        "SID": person.SID,   (int)
        "Branch":person.Branch,     (string)
        "Year": person.Year,    (int)
        "Semester": person.Semester,    (int) 
        "Clubs": club_list  (list of strings of names of clubs)
        "Insta" : insta_hand (string)
    }
    eg 
    http://127.0.0.1:5000/social?query=editorial -- [GET]

    returns - 
    [
        {
            "Name": "Kalash Jain"
            "SID": 19103096
            "Branch": "Computer Science Engineering"
            "Year": 2
            "Semester": 4
            "Clubs": ["English Editorial Board", "Music club"],
            "Insta" : "kalashjain_"
        },
        {
            "Name": "Isha Garg"
            "SID": 19103109
            "Branch": "Computer Science Engineering"
            "Year": 2
            "Semester": 4
            "Clubs": ["English Editorial Board", "PDC"],
            "Insta" : "-"
        }

        "Insta" : "-" means student does not have any instagram handle attached
        
    
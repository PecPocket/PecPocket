# Documentation for Notifications Backend api


## 1. POST notifications 

    href - ../noti/<SID> -- [POST] --> SID of the user posting the notification is given
    body - 
    {
        "Topic" : "Topic for the notification" (string),
        "Description" : "description for the notification" (string)
        "Date" : "of format dd-mm-yyyy" (string)
        "Time" : "of format H:M AM/PM" (string)
    }

    returns - 
    {
        'code' : x
    }
    x -> 401 : the SID with Auth=2 has no club domain i.e is a secy/secy of no club
    x -> 403 : that club has no students 
    x -> 200 : if notification is posted 

    eg
    http://127.0.0.1:5000/noti/19103098 -- [POST]

    body - 
    {
        "Topic" : "EAD quiz",
        "Description" : "Quiz syllabus -> until taught in class",
        "Date" : "30-04-2021",
        "Time" : "10:30 AM"
    }


## 2. GET notifications for a particular SID

    href - ../noti/<SID> -- [GET]  --> SID of the user whose notifications are to be displayed
    body - null

    returns - 
    i. error messages
    {
        'code' : x
    }
    x -> 405 : if the user has an entry in student notification but the corresponding notification doesn't exist (not of use)
    x -> 406 : if the student has no notifications 

    ii. list of notifications

    eg 
    
    http://127.0.0.1:5000/noti/19103109 -- [GET]

    returns - 
    {
        "Notifications": [
            {
                "Date": "28-05-2021",
                "Description": "Quiz syllabus -> until taught in class",
                "Time": "06:30 PM",
                "Topic": "EAD quiz"
            },
            {
                "Date": "30-05-2021",
                "Description": "Quiz syllabus -> until taught in class",
                "Time": "04:30 PM",
                "Topic": "DBMS quiz"
            }
        ]
    }
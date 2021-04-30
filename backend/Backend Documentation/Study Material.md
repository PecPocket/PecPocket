# Documentation for Study Material Backend api

## 1. Upload a file to backend 

    href - ../upload/<subject_code> -- [POST]
    body - {
        'file' : (attach image here)
    }

    returns - 
    i. if there is no file attached
    {
        'code' : 404
    }

    ii. if image is successfully uploaded 
    {
        'code':200
    }



## 2. GET all uploaded files for a particular subject

    href - ../getuploads/<subject_code> -- [GET]
    body - null

    returns - 
    i. error messages
    {
        'code':x
    }
    x -> 405 : there is no directory for that subject
    x -> 406 : the subject directory is empty and has no files

    ii. List of uploaded files for that subject

    eg
    http://127.0.0.1:5000/getuploads/CSN103 -- [GET]

    returns -
    {
        "Uploads": [
            "test_image.jpeg",
            "test2.jpeg"
        ]
    }



## 3. Download file from backend/ Send it to the app

    href - ../download/<subject_code>/<image_name>  -- [GET]
    body - null

    returns - 
    i. if file not found 
    {
        'code':404
    }

    ii. if file is found
    {
        -- returns the file asked for -- 
    }


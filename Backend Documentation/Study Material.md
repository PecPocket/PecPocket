# Documentation for Study Material Backend api

## 1. Upload an image to backend static

    href - ../upload/image -- [POST]
    body - {
        'image' : (attach image here)
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


## 2. Upload PDF to image static

    href - ../upload/pdf -- [POST]
    body - {
        'pdf' : (attach pdf)
    }

    returns - 
    i. if there is no file attached
    {
        'code':404
    }

    ii. if the pdf is successfully uploaded 
    {
        'code':200
    }


## 3. Download image from backend/ Send it to the app

    href - ../download/image/<image_name>  -- [GET]
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


## 4. Download pdf from backend/ Send it to the app

    href - ../download/pdf/<pdf_name>  -- [GET]
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

/*==============================================================================

                        v_security.inc
                        Author: #Djuga
                Copyright (c) 2018 Dmitriy Djuga (#Djuga)
                        
==============================================================================*/

#if defined V_SECURITY
    #endinput
#endif

#define V_SECURITY

#if !defined VK_DOMAIN
    #define VK_DOMAIN "srv.9ab.ru"
#endif

#if !defined HTTP

#define HTTP_GET                        1
#define HTTP_POST                       2
#define HTTP_HEAD                       3
#define HTTP_ERROR_BAD_HOST             1
#define HTTP_ERROR_NO_SOCKET            2
#define HTTP_ERROR_CANT_CONNECT         3
#define HTTP_ERROR_CANT_WRITE           4
#define HTTP_ERROR_CONTENT_TOO_BIG      5
#define HTTP_ERROR_MALFORMED_RESPONSE   6

native HTTP(index, type, url[], data[], callback[]);

#endif
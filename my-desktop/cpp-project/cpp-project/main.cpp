#include <iostream>
#include <mysql.h>

//#define EXAMPLE_HOST "localhost"
//#define EXAMPLE_USER "root"
//#define EXAMPLE_PASS "12345678"
//#define EXAMPLE_DB "jbdatabase"

/// TO LINK Lib search for "Header search paths" and add path to lib 'include' folder.

int main(int argc, const char * argv[]) {
    
//    MYSQL *conn;
//    MYSQL_RES *res;
//    MYSQL_ROW row;
//
//    char *server = "localhost";
//    char *user = "root";
//    char *password = "12345678";
//    char *database = "jbdatabase";
    
    
//    conn = mysql_init(NULL);
    
    /* Connect to database */
//    if (!mysql_real_connect(conn, server,
//                            user, password, database, 0, NULL, 0)) {
//        fprintf(stderr, "%s\n", mysql_error(conn));
//        exit(1);
//    }

    /* send SQL query */
//    if (mysql_query(conn, "show tables")) {
//        fprintf(stderr, "%s\n", mysql_error(conn));
//        exit(1);
//    }
//
//    res = mysql_use_result(conn);

    /* output table name */
//    printf("MySQL Tables in mysql database:\n");
//    while ((row = mysql_fetch_row(res)) != NULL)
//        printf("%s \n", row[0]);

    /* close connection */
//    mysql_free_result(res);
//    mysql_close(conn);
    
    return 0;
}

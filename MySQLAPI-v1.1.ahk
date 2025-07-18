; ======================================================================================================================
; Wrapper class for MySQL C API functions        -> http://dev.mysql.com/doc/refman/5.5/en/c-api-functions.html
; Based on "MySQL Library functions" by panofish -> http://www.autohotkey.com/board/topic/72629-mysql-library-functions
; AHK version: V2 2.02+ 64bit
; Author:      panofish/just me
; Version:     1.0.01.00/2015-08-20/just me        - libmysql.dll error handling
;                  1.0.00.00/2013-06-15/just me
;Converted for AHKV2 1.0.00.00/2023-02-07/tre4shunter
;
;Example Usage
;ClassInst := MySql()
;ClassInst.Real_Connect("Host","UserName","Password","dbname")
;QueryResult := ClassInst.Query(ClassInst.Real_Escape_String("Select * From Salesmen"))
;if(QueryResult = 0){
;    ResultSet := ClassInst.GetResult()
;    for k,v in ResultSet.Fields
;        MsgBox(v.Name)
;}
;
; Remarks:
; The character encoding depends on the character set used by the current connection. That's why the code page for
; all connections is set to UTF-8 within the __New() meta-function. String conversions are done internally
; whenever possible.
; ======================================================================================================================

Class MySql {
    static FIELD_TYPE := Map(
    0, "DECIMAL", 1, "TINY", 2, "SHORT", 3, "LONG", 4, "FLOAT", 5, "DOUBLE", 6, "NULL"
    , 7, "TIMESTAMP", 8, "LONGLONG", 9, "INT24", 10, "DATE", 11, "TIME", 12, "DATETIME"
    , 13, "YEAR", 14, "NEWDATE", 15, "VARCHAR", 16, "BIT",63,"UNKNOWN", 256, "NEWDECIMAL", 247, "ENUM"
    , 248, "SET", 249, "TINY_BLOB", 250, "MEDIUM_BLOB", 251, "LONG_BLOB", 252, "BLOB"
    , 253, "VAR_STRING", 254, "STRING", 255, "GEOMETRY"
    )
    
    static FIELD_FLAG := Map(
        "NOT_NULL", 1, "PRI_KEY", 2, "UNIQUE_KEY", 4, "MULTIPLE_KEY", 8, "BLOB", 16, "UNSIGNED", 32
        , "ZEROFILL", 64, "BINARY", 128, "ENUM", 256, "AUTO_INCREMENT", 512, "TIMESTAMP", 1024, "SET", 2048
        , "NO_DEFAULT_VALUE", 4096, "NUM",	32768
    )

    static MySql_SUCCESS := 0

    static __New(LibPath := "") {
        Static libmysql := A_ScriptDir "\libmysql.dll"
        ; Do not instantiate instances! -> What does this mean?  Is it even needed in V2?
        If (This.Base.Base.__Class = "MySql") {
           MsgBox("You must not instantiate instances of MySQLDB!","MySQL Error!",16)
           Return(False)
        }

        ; Load libmysql.dll
        If (LibPath)
           libmysql := LibPath
        If !(MySQLM := DllCall("Kernel32.dll\LoadLibrary", "Str", libmysql, "UPtr")) {
           If (A_LastError = 126) ; The specified module could not be found
              MsgBox("Could not find " libmysql "!","MySql Error!", 16)
           Else {
              ErrCode := A_LastError
              VarSetStrCapacity(&ErrMsg, 131072)
              DllCall("FormatMessage", "UInt", 0x1200, "Ptr", 0, "UInt", ErrCode, "UInt", 0, "Str", ErrMsg, "UInt", 65536, "Ptr", 0)
              MsgBox("Could not load " libmysql "!`nError code: " ErrCode "`n" ErrMsg,"MySql Error!",16)
           }
           Return(False)
        }
        this.Module := MySQLM
        If !(this.MYSQLh := This.Initialize()) {
            MsgBox("Could not initialize MySQL!")
            Return(False)
         }
        this.Connected := False
     }

     UTF8(Str) {
        buf := Buffer(StrPut(str, "UTF-8"))
        StrPut(str, buf, "UTF-8")
        return buf
     }

     static Initialize(MYSQL := 0) {
        Return(DllCall("libmysql.dll\mysql_init", "Ptr", MYSQL, "UPtr"))
     }

     Real_Connect(Host, User, PassWd, DB := "", Port := 3306, Socket := 0, Flags := 0) {
        If (DB = "")
           PtrDB := 0
        Else
           PtrDB := This.UTF8(DB)

        If !(MYSQLi := DllCall("libmysql.dll\mysql_real_connect", "Ptr", MySql.MYSQLh, "Ptr", This.UTF8(Host)
                            , "Ptr", This.UTF8(User), "Ptr", This.UTF8(PassWd), "Ptr", PtrDB
                            , "UInt", Port, "Ptr", This.UTF8(Socket), "Uint", Flags, "UPtr"))
        Return (False)
        
        Return (MYSQLi)
  
     }

     Query(SQL) {
        Return DllCall("libmysql.dll\mysql_query", "Ptr", MySql.MYSQLh, "Ptr", This.UTF8(SQL), "Int")
     }
     GetResult() {
        If !(MYSQL_RES := This.Store_Result())
              Return False
        Result := {}
        Result.RowsCount := This.Num_Rows(MYSQL_RES)
        Result.ColumnsCount := This.Num_Fields(MYSQL_RES)
        Result.Fields := Map()
        Result.Rows := Map()
        While(MYSQL_FIELD := This.Fetch_Field(MYSQL_RES))
           Result.Fields[A_Index] := This.GetField(MYSQL_FIELD)
        While (Row := This.GetNextRow(MYSQL_RES, Result.Fields))
           Result.Rows[A_Index] := Row
        This.Free_Result(MYSQL_RES)
        Return Result
     }
     GetField(MYSQL_FIELD) {
        Field := {}
        Offset := 0
        Field.Name      := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        Field.OrgName   := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        Field.Table     := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        Field.OrgTable  := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        Field.DB        := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        Field.Catalog   := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        ;Field.Default   := StrGet(NumGet(MYSQL_FIELD + 0, Offset, "UPtr"), "UTF-8"), Offset += A_PtrSize
        Field.Length    := NumGet(MYSQL_FIELD + 0, Offset, "UInt"), Offset += 4
        Field.MaxLength := NumGet(MYSQL_FIELD + 0, Offset, "UInt"), Offset += 4 * 8 ; skip string length fields
        Field.Flags     := NumGet(MYSQL_FIELD + 0, Offset, "UInt"), Offset += 4
        Field.Decimals  := NumGet(MYSQL_FIELD + 0, Offset, "UInt"), Offset += 4
        Field.CharSetNr := NumGet(MYSQL_FIELD + 0, Offset, "UInt"), Offset += 4
        Field.Type      := MySql.FIELD_TYPE[NumGet(MYSQL_FIELD + 0, Offset, "UInt")]
        Return(Field)
     }
     
     GetNextRow(MYSQL_RES, FIELDS) {
        If (MYSQL_ROW := This.Fetch_Row(MYSQL_RES)) {
           Row := Map()
           Lengths := This.Fetch_Lengths(MYSQL_RES)
            loop(this.Num_Fields(MYSQL_RES)) {
                J := A_Index - 1

                If (Len := NumGet(Lengths + 0, 4 * J, "UInt")){
					Row[FIELDS[A_Index].Name] := (StrGet(NumGet(MYSQL_ROW + 0, A_PtrSize * J, "UPtr"), Len, "UTF-8"))
                 }Else{
					Row[FIELDS[A_Index].Name] := ""
                 }
            }
            Return(Row)
        }
        Return(False)
     }
     
     Store_Result() {
        Return DllCall("libmysql.dll\mysql_store_result", "Ptr", MySql.MYSQLh, "UPtr")
     }
     Num_Rows(MYSQL_RES) {
        Return DllCall("libmysql.dll\mysql_num_rows", "Ptr", MYSQL_RES, "UInt64")
     }
     Num_Fields(MYSQL_RES) {
        Return DllCall("libmysql.dll\mysql_num_fields", "Ptr", MYSQL_RES, "UInt")
     }
     Fetch_Field(MYSQL_RES) {
        Return DllCall("libmysql.dll\mysql_fetch_field", "Ptr", MYSQL_RES, "UPtr")
     }
     Fetch_Row(MYSQL_RES) {
        Return DllCall("libmysql.dll\mysql_fetch_row", "Ptr", MYSQL_RES, "UPtr")
     }
     Fetch_Lengths(MYSQL_RES) {
        Return DllCall("libmysql.dll\mysql_fetch_lengths", "Ptr", MYSQL_RES, "UPtr")
     }
     Fetch_Field_Direct(MYSQL_RES, FieldNr) {
        Return DllCall("libmysql.dll\mysql_fetch_field_direct", "Ptr", MYSQL_RES, "UInt", FieldNr, "UPtr")
     }
     Free_Result(MYSQL_RES) {
        DllCall("libmysql.dll\mysql_free_result", "Ptr", MYSQL_RES)
     }
     Get_Client_Info() {
        Return ((S := DllCall("libmysql.dll\mysql_get_client_info", "UPtr")) ? StrGet(S, "UTF-8") : "")
     }
     Ping() {
        Return DllCall("libmysql.dll\mysql_ping", "Ptr", MySql.MYSQLh, "Int")
     }
     Get_Client_Version() {
        Return DllCall("libmysql.dll\mysql_get_client_version", "Int")
     }
     Get_Host_Info() {
        Return ((P := DllCall("libmysql.dll\mysql_get_host_info", "Ptr", MySql.MYSQLh, "UPtr")) ? StrGet(P, "UTF-8") : "")
     }
     Get_Proto_Info() {
        Return DllCall("libmysql.dll\mysql_get_proto_info", "Ptr", MySql.MYSQLh, "UInt")
     }
     Get_Server_Info() {
        Return ((P := DllCall("libmysql.dll\mysql_get_server_info", "Ptr", MySql.MYSQLh, "UPtr")) ? StrGet(P, "UTF-8") : "")
     }
     Get_Server_Version() {
        Return DllCall("libmysql.dll\mysql_get_server_version", "Ptr", MySql.MYSQLh, "UInt")
     }
     Info() {
        Return ((S := DllCall("libmysql.dll\mysql_info", "Ptr", MySql.MYSQLh, "UPtr")) ? StrGet(S, "UTF-8") : "")
     }
     Insert_ID() {
        Return DllCall("libmysql.dll\mysql_insert_id", "Ptr", MySql.MYSQLh, "UInt64")
     }
     List_Fields(Table, Like := "") {
        Return DllCall("libmysql.dll\mysql_list_fields", "Ptr", MySql.MYSQLh, "Ptr", This.UTF8(Table)
                     , "Ptr", (Like = "" ? 0 : This.UTF8(Like)), "UPtr")
     }
     List_Tables(Like := "") {
        Return DllCall("libmysql.dll\mysql_list_tables", "Ptr", MySql.MYSQLh
                     , "Ptr", (Like = "" ? 0 : This.UTF8(Like)), "UPtr")
     }
     More_Results() {
        Return DllCall("libmysql.dll\mysql_more_results", "Ptr", MySql.MYSQLh, "Char")
     }
     Next_Result() {
        Return DllCall("libmysql.dll\mysql_next_result", "Ptr", MySql.MYSQLh, "Int")
     }
     Real_Escape_String(From) {
        L := StrPut(From, "UTF-8") - 1
        SO := Buffer((L * 2) + 1)
        N := DllCall("libmysql.dll\mysql_real_escape_string", "Ptr", MySql.MYSQLh, "Ptr", SO, "Ptr", this.UTF8(From), "UInt", L, "UInt")
        Return StrGet(SO, N, "UTF-8")
     }
     Real_Query(SQL, Length) {
        Return DllCall("libmysqlx64.dll\mysql_real_query", "Ptr", MySql.MYSQLh, "Ptr", SQL, "UInt", Length, "Int")
     }
     Rollback() {
        Return DllCall("libmysqlx64.dll\mysql_rollback", "Ptr", MySql.MYSQLh, "Char")
     }
     Row_Seek(MYSQL_RES, Offset) {
        Return DllCall("libmysqlx64.dll\mysql_row_seek", "Ptr", MYSQL_RES, "Ptr", Offset, "UPtr")
     }
     Row_Tell(MYSQL_RES) {
        Return DllCall("libmysqlx64.dll\mysql_row_tell", "Ptr", MYSQL_RES, "UPtr")
     }
     Select_DB(DB) {
        Return DllCall("libmysqlx64.dll\mysql_select_db", "Ptr", MySql.MYSQLh, "Ptr", This.UTF8(DB), "Int")
     }
     Set_Character_Set(CSName) {
        Return DllCall("libmysqlx64.dll\mysql_set_character_set", "Ptr", MySql.MYSQLh, "Ptr", This.UTF8(CSName), "Int")
     }
     Set_Server_Option(Option) {
        Return DllCall("libmysqlx64.dll\mysql_set_server_option", "Ptr", MySql.MYSQLh, "Int", Option, "Int")
     }
     SQLState() {
        Return ((P := DllCall("libmysqlx64.dll\mysql_sqlstate", "Ptr", MySql.MYSQLh, "UPtr")) ? StrGet(P, "UTF-8") : "")
     }
     Stat() {
        Return ((P := DllCall("libmysqlx64.dll\mysql_stat", "Ptr", MySql.MYSQLh, "UPtr")) ? StrGet(P, "UTF-8") : "")
     }
     Thread_ID() {
        Return DllCall("libmysqlx64.dll\mysql_thread_id", "Ptr", MySql.MYSQLh, "UInt")
     }
     Use_Result() {
        Return DllCall("libmysqlx64.dll\mysql_use_result", "Ptr", MySql.MYSQLh, "UPtr")
     }
     Warning_Count() {
        Return DllCall("libmysqlx64.dll\mysql_warning_count", "Ptr", MySql.MYSQLh, "UInt")
     }
     Options(Option, Arg) {
        Static MySQL_Option := {MYSQL_OPT_CONNECT_TIMEOUT: 0, MYSQL_OPT_COMPRESS: 1, MYSQL_OPT_NAMED_PIPE: 2
                              , MYSQL_INIT_COMMAND: 3, MYSQL_READ_DEFAULT_FILE: 4, MYSQL_READ_DEFAULT_GROUP: 5
                              , MYSQL_SET_CHARSET_DIR: 6, MYSQL_SET_CHARSET_NAME: 7, MYSQL_OPT_LOCAL_INFILE: 8
                              , MYSQL_OPT_PROTOCOL: 9, MYSQL_SHARED_MEMORY_BASE_NAME: 10, MYSQL_OPT_READ_TIMEOUT: 11
                              , MYSQL_OPT_WRITE_TIMEOUT: 12, MYSQL_OPT_USE_RESULT: 13
                              , MYSQL_OPT_USE_REMOTE_CONNECTION: 14, MYSQL_OPT_USE_EMBEDDED_CONNECTION: 15
                              , MYSQL_OPT_GUESS_CONNECTION: 16, MYSQL_SET_CLIENT_IP: 17, MYSQL_SECURE_AUTH: 18
                              , MYSQL_REPORT_DATA_TRUNCATION: 19, MYSQL_OPT_RECONNECT: 20
                              , MYSQL_OPT_SSL_VERIFY_SERVER_CERT: 21, MYSQL_PLUGIN_DIR: 22, MYSQL_DEFAULT_AUTH: 23
                              , MYSQL_ENABLE_CLEARTEXT_PLUGIN: 24}
        If !IsInteger(Option)
           Option := MYSQL_Option[Option]
        If IsInteger(Arg)
           Return DllCall("libmysq.dll\mysql_options", "Ptr", MySql.MYSQLh, "Int", Option, "Int64P", Arg, "Int")
        Return DllCall("libmysql.dll\mysql_options", "Ptr", MySql.MYSQLh, "Int", Option, "Ptr", This.UTF8(Arg), "Int")
     }
}



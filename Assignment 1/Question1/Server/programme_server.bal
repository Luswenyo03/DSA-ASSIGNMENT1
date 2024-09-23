import ballerina/http;

listener http:Listener httpListener = new (8080);

public type Programme record {|
    readonly string programme_code;
    int nqf_level;
    string faculty_name;
    string department_name;
    string programme_title;
    string reg_date;
    Course[] courses;
|};

public type Course record {|
    readonly string courseCode;
    string courseName;
    int nqf_level;
|};

public type FacultyNamesResponse record {
    string[] faculty_names;
};

public type ConflictingProgrammeCodesError record {|
    *http:Conflict;
    ErrorMsg body;
|};

public type InvalidProgrammeCodeError record {|
    *http:NotFound;
    ErrorMsg body;
|};

public type ErrorMsg record {|
    string errmsg;
|};

public final table<Programme> key(programme_code) programmeTable = table [];
service /pdu on httpListener {

    //Add a new programme
    resource function post programme(@http:Payload Programme programme) returns Programme|ConflictingProgrammeCodesError|error {
        if (programmeTable.hasKey(programme.programme_code)) {
            return {
                body: {
                    errmsg: "Programme already exists"
                }
            };
        } else {

            //string reviewDate = check calculateReviewDate(programme.reg_date, 5); // 5 years from reg_date
            //programme.review_date = reviewDate;
            programmeTable.add(programme);
            return programme;
        }
    }

   

}

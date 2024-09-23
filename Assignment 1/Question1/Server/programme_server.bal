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

//Retrieve details of a specific programme by programme code
    resource function get programme/[string programme_code]() returns Programme|InvalidProgrammeCodeError {
        Programme? programme = programmeTable[programme_code];
        if programme is () {
            return {
                body: {
                    errmsg: string `Invalid programme code: ${programme_code}`
                }
            };
        }
        return programme;
    }

//Update an existing programme's information according to the programme code
    resource function put updateProgramme/[string programme_code](@http:Payload Programme programme) returns InvalidProgrammeCodeError|error|Programme {
        Programme? existingProgramme = programmeTable[programme_code];

        if (existingProgramme is Programme) {
            // Update the existing programme details
            existingProgramme.nqf_level = programme.nqf_level;
            existingProgramme.faculty_name = programme.faculty_name;
            existingProgramme.department_name = programme.department_name;
            existingProgramme.courses = programme.courses;

            // Update programme_title only if provided and not empty
            if (programme.programme_title != "") {
                existingProgramme.programme_title = programme.programme_title;
            }

            // Update reg_date only if provided and not empty
            if (programme.reg_date != "") {
                existingProgramme.reg_date = programme.reg_date;
            }
            // Put the updated programme back into the table
            programmeTable.put(existingProgramme);

            return existingProgramme;
        } else {
            return {
                body: {
                    errmsg: string `Invalid programme code: ${programme_code}`
                }
            };
        }
    }

}

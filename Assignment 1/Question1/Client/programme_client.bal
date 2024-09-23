import ballerina/http;
import ballerina/io;

string baseUrl = "http://localhost:8080/pdu";
http:Client pduclient = check new (baseUrl);

public type Programme record {|
    string programme_code;
    int nqf_level;
    string faculty_name;
    string department_name;
    string programme_title;
    string reg_date;
    //string review_date;
    Course[] courses;
|};

public type Course record {|
    string courseCode;
    string courseName;
    int nqf_level;
|};

public type FacultyNamesResponse record {
    string[] faculty_names;
};

public type ErrorMsg record {|
    string errmsg;
|};

// Helper function to read user input
function getInput(string prompt) returns string {
    io:print(prompt);
    string? userInput = io:readln();
    return userInput ?: "";
}

function addProgramme() returns Programme|ErrorMsg|error {
    io:println("\n***** Programme Info *****");

    // Capture programme details
    string programmeCode = getInput("\nEnter Programme Code: ");
    int nqfLevel = check getValidatedIntegerInput("Enter NQF Level (integer): ");
    string facultyName = getInput("Enter Faculty Name: ");
    string departmentName = getInput("Enter Department Name: ");
    string programmeTitle = getInput("Enter Programme Title: ");
    string regDate = getInput("Enter Registration Date (YYYY-MM-DD): ");

    io:println("\n***** Course Info *****");

    // Capture course details, handle errors if any
    Course[] courses = check collectCourses();

    // Programme creation
    Programme programme = {
        programme_code: programmeCode,
        nqf_level: nqfLevel,
        faculty_name: facultyName,
        department_name: departmentName,
        programme_title: programmeTitle,
        reg_date: regDate,
        courses: courses
    };

    // POST request to add the programme
    Programme|error response = pduclient->/programme.post(programme);
    if (response is Programme) {
        return response;
    } else {
        ErrorMsg errorMsg = {errmsg: "Failed to add the programme."};
        return errorMsg;
    }
}

// Function to retrieve all programmes from the server
function retrieveProgrammes() returns Programme[]|ErrorMsg|error {
    // Send a GET request to retrieve all programmes
    Programme[]|error response = pduclient->/programmes.get();

    // Check if the response is successful or contains an error
    if (response is Programme[]) {
        return response;
    } else {
        ErrorMsg errorMsg = {errmsg: "Failed to retrieve programmes."};
        return errorMsg;
    }
}

// Function to get a programme by code
function getProgrammeByCode(string programmeCode) returns Programme|ErrorMsg|error {
    Programme|error response = pduclient->get(string `/programme/${programmeCode}`);

    if (response is Programme) {
        return response;
    } else {
        ErrorMsg errorMsg = {errmsg: "Failed to retrieve programmes."};
        return errorMsg;
    }
}

// Function to update an existing programme interactively
function updateProgramme() returns Programme|ErrorMsg|error? {
    string programmeCode = getInput("\nEnter Programme Code to update: ");

    // Retrieve existing programme
    Programme|ErrorMsg existingProgrammeResult = check getProgrammeByCode(programmeCode);
    if (existingProgrammeResult is ErrorMsg) {
        io:println("\nProgramme not found.\n");
        return existingProgrammeResult;
    }

    // Get the existing programme details
    Programme existingProgramme = existingProgrammeResult;

    // Update basic details
    existingProgramme.nqf_level = check 'int:fromString(getInput("\nEnter new NQF Level (integer): "));
    existingProgramme.faculty_name = getInput("Enter new Faculty Name: ");
    existingProgramme.department_name = getInput("Enter new Department Name: ");

    // Ask user if they want to change Programme Title
    string changeTitle = getInput("\nDo you want to change the Programme Title? (y/n): ");
    if (changeTitle == "y" || changeTitle == "Y") {
        existingProgramme.programme_title = getInput("\nEnter new Programme Title: ");
    }

    // Ask user if they want to change Registration Date
    string changeRegDate = getInput("\nDo you want to change the Registration Date? (y/n): ");
    if (changeRegDate == "y" || changeRegDate == "Y") {
        existingProgramme.reg_date = getInput("\nEnter new Registration Date (YYYY-MM-DD): ");
    }

    // Collect new courses, update existing courses or delete courses
    existingProgramme.courses = check manageCourses(existingProgramme.courses);

    // Post updated programme to the server
    Programme|error response = pduclient->put(string `/updateProgramme/${programmeCode}`, existingProgramme);

    if (response is Programme) {
        return response;
    } else {
        io:println("Error occurred while updating the programme.");
        return response;
    }
}

// Function to manage courses: add, delete, or update
function manageCourses(Course[] currentCourses) returns Course[]|error {
    io:println("\nManage courses:\n");
    io:println("1. Add new course");
    io:println("2. Delete a course");
    io:println("3. Update existing course");
    int choice = check 'int:fromString(getInput("\nChoose an option (1/2/3): "));

    if (choice == 1) {
        // Add new courses
        return check addCourses(currentCourses);
    } else if (choice == 2) {
        // Delete a course
        return deleteCourse(currentCourses);
    } else if (choice == 3) {
        // Update existing courses
        return updateCourse(currentCourses);
    } else {
        io:println("\nInvalid choice.\n");
        return currentCourses;
    }
}

// Function to add new courses
function addCourses(Course[] currentCourses) returns Course[]|error {
    Course[] updatedCourses = currentCourses; // Directly assign the currentCourses to updatedCourses
    boolean addMore = true;

    while (addMore) {
        Course newCourse = {courseCode: "", courseName: "", nqf_level: 7};
        newCourse.courseCode = getInput("\nEnter new Course Code: ");
        newCourse.courseName = getInput("Enter new Course Name: ");
        newCourse.nqf_level = check 'int:fromString(getInput("Enter new NQF Level (integer): "));

        updatedCourses.push(newCourse);

        string moreCourses = getInput("\nDo you want to add another course? (y/n): ");
        if (moreCourses != "y" && moreCourses != "Y") {
            addMore = false;
        }
    }

    return updatedCourses;
}

// Function to delete a course
function deleteCourse(Course[] currentCourses) returns Course[] {
    io:println("\nCurrent courses:\n");
    foreach Course course in currentCourses {
        io:println("Code: " + course.courseCode + ", Name: " + course.courseName);
    }

    string courseCodeToDelete = getInput("\nEnter the Course Code to delete: ");
    Course[] updatedCourses = [];

    foreach Course course in currentCourses {
        if (course.courseCode != courseCodeToDelete) {
            updatedCourses.push(course);
        }
    }

    return updatedCourses;
}

// Function to update a course
function updateCourse(Course[] currentCourses) returns Course[] {
    io:println("\nCurrent courses:\n");
    foreach Course course in currentCourses {
        io:println("Code: " + course.courseCode + ", Name: " + course.courseName);
    }

    string courseCodeToUpdate = getInput("\nEnter the Course Code to update: ");
    Course[] updatedCourses = [];
    boolean courseUpdated = false;

    foreach Course course in currentCourses {
        if (course.courseCode == courseCodeToUpdate) {
            io:println("\nUpdating course: " + course.courseCode);
            course.courseName = getInput("Enter new Course Name: ");

            string nqfLevelInput = getInput("Enter new NQF Level (integer): ");
            int|error nqfLevelResult = int:fromString(nqfLevelInput);

            if (nqfLevelResult is int) {
                course.nqf_level = nqfLevelResult;
            } else {
                io:println("\nInvalid NQF Level. Keeping the old value.\n");
            }

            courseUpdated = true;
        }
        updatedCourses.push(course);
    }

    if (!courseUpdated) {
        io:println("\nNo course found with code: " + courseCodeToUpdate);
    }

    return updatedCourses;
}

// Function to delete a programme interactively
function deleteProgramme() returns ErrorMsg? {
    string programmeCode = getInput("\nEnter Programme Code to delete: ");

    // Send DELETE request to the server
    http:Response|error response = pduclient->delete(string `/deleteProgram/${programmeCode}`);

    if (response is http:Response) {
        if (response.statusCode == 200) {
            io:println("\nProgramme deleted successfully.\n");
            return;
        } else {
            io:println("\nUnexpected error format received from server.\n");
            return;
        }
    } else {
        io:println("\nError occurred while deleting the programme.\n");
        return;
    }
}

// Function to retrieve all faculty names
function getFaculties() returns FacultyNamesResponse|ErrorMsg|error {

    // Send a GET request to the server
    FacultyNamesResponse|error response = pduclient->get("/faculties");

    // Check if the response is a FacultyNamesResponse or an error
    if (response is FacultyNamesResponse) {
        return response;
    } else {
        // Return an error message if retrieval failed
        ErrorMsg errorMsg = {errmsg: "Failed to retrieve faculties."};
        return errorMsg;
    }
}

// Function to retrieve all programmes by faculty name
function getProgrammeByFaculty() returns Programme[]|ErrorMsg|error {

    io:println("\n Available Faculties:\n");

    // Retrieve the list of faculties
    FacultyNamesResponse|ErrorMsg|error result = getFaculties();

    // Handle the result
    if (result is FacultyNamesResponse) {
        // Display all available faculties
        int count = 1;
        foreach var faculty in result.faculty_names {
            io:println(" #" + count.toString() + ". " + faculty);
            count = count + 1;
        }
    } else if (result is ErrorMsg) {
        return result; // Return the ErrorMsg if it failed to retrieve faculties
    } else {
        return error("\n Failed to retrieve faculties.\n");
    }

    // Get user input for faculty name
    string facultyNameCode = getInput("\nEnter Faculty Name: ");

    // Construct the URL properly and send GET request to retrieve programmes
    Programme[]|error response = pduclient->get(string `/programmes/faculty/${facultyNameCode}`);

    if (response is Programme[]) {
        return response;
    } else {
        // Return an error message if retrieval failed
        ErrorMsg errorMsg = {errmsg: "\nFailed to retrieve programmes.\n"};
        return errorMsg;
    }
}

function getReviewProgramme() returns Programme[]|ErrorMsg|error {

    Programme[]|error response = pduclient->get("/reviewProgrammes");

    // Check if the response is a FacultyNamesResponse or an error
    if (response is Programme[]) {
        return response;
    } else {
        // Return an error message if retrieval failed
        ErrorMsg errorMsg = {errmsg: "Failed to retrieve review programmes."};
        return errorMsg;
    }
}

// Function to capture and validate integer input
function getValidatedIntegerInput(string prompt) returns int|error {
    while true {
        string input = getInput(prompt);
        var result = int:fromString(input);
        if (result is int) {
            return result;
        } else {
            io:println("Invalid input. Please enter an integer value.");
        }
    }
}

// Function to collect courses from the user
function collectCourses() returns Course[]|error {
    Course[] courses = [];
    string addAnotherCourse = "y";

    while addAnotherCourse == "y" || addAnotherCourse == "Y" {
        string courseCode = getInput("\nEnter Course Code: ");
        string courseName = getInput("Enter Course Name: ");
        int courseNQFLevel = check getValidatedIntegerInput("Enter Course NQF Level (integer): ");

        Course newCourse = {courseCode: courseCode, courseName: courseName, nqf_level: courseNQFLevel};
        courses.push(newCourse);

        addAnotherCourse = getValidatedYesNoInput("\nAdd another course? (y/n): ");
    }
    return courses;
}

// Function to validate 'y' or 'n' input
function getValidatedYesNoInput(string prompt) returns string {
    while true {
        string input = getInput(prompt);
        if (input == "y" || input == "Y" || input == "n" || input == "N") {
            return input;
        } else {
            io:println("Invalid input. Please enter 'y' or 'n'.");
        }
    }
}

// Function to display a Programme object
function displayProgramme(Programme programme) {

    io:println(" Programme Code: " + programme.programme_code);
    io:println(" NQF Level: " + programme.nqf_level.toString());
    io:println(" Faculty Name: " + programme.faculty_name);
    io:println(" Department Name: " + programme.department_name);
    io:println(" Programme Title: " + programme.programme_title);
    io:println(" Registration Date: " + programme.reg_date);

    io:println("\n Courses:\n");
    foreach Course course in programme.courses {
        io:println("  Course Code: " + course.courseCode);
        io:println("  Course Name: " + course.courseName);
        io:println("  NQF Level: " + course.nqf_level.toString());
        io:println(); // Adds a blank line for readability
    }
}

// Main function to handle user choices
public function main() returns error? {
    while true {
        io:println("\n==== Programme Management System ====");
        io:println("");
        io:println("1. Add a new programme");
        io:println("2. Retrieve all programmes");
        io:println("3. Update an existing programme");
        io:println("4. Retrieve programmes");
        io:println("5. Delete programme");
        io:println("6. Retrieve review programme");
        io:println("7. Retrieve all programmes by faculty");
        io:println("8. Exit");

        int choice = check int:fromString(getInput("\nChoose an option (1-7): "));

        if (choice == 1) {
            Programme|ErrorMsg? result = check addProgramme();
            if (result is Programme) {
                io:println("\n Programme added successfully ");
                displayProgramme(result);
            } else if (result is ErrorMsg) {
                io:println("Error: " + result.errmsg);
            }
        } else if (choice == 2) {

            Programme[]|ErrorMsg|error result = retrieveProgrammes();

            if (result is Programme[]) {
                io:println("\n*** " + result.length().toString() + " programmes retrieved ***\n");
                int count = 1;

                foreach Programme programme in result {
                    io:println("Programme #" + count.toString() + "\n");
                    displayProgramme(programme);
                    count = count + 1;
                }
            } else if (result is ErrorMsg) {
                io:println("Error: " + result.errmsg);
            } else {
                io:println("An error occurred while retrieving the programmes.");
            }

        } else if (choice == 3) {

            Programme|ErrorMsg? result = check updateProgramme();
            if (result is Programme) {
                io:println("\n Programme updated successfully \n");
                displayProgramme(result);
            } else if (result is ErrorMsg) {
                io:println("Error: " + result.errmsg);
            }

        } else if (choice == 4) {
            string programmeCode = getInput("\nEnter Programme Code: ");
            Programme|ErrorMsg result = check getProgrammeByCode(programmeCode);

            if (result is Programme) {
                io:println("\nProgramme retrieved successfully:\n");
                displayProgramme(result);
            } else {
                io:println("Error: " + result.errmsg);
            }
        } else if (choice == 5) {
            ErrorMsg? _ = deleteProgramme();

        } else if (choice == 6) {

            Programme[]|ErrorMsg|error result = getReviewProgramme();

            if (result is Programme[]) {
                io:println("\n*** " + result.length().toString() + " programmes retrieved ***\n");
                int count = 1;

                foreach Programme programme in result {
                    io:println("Programme #" + count.toString() + "\n");
                    displayProgramme(programme);
                    count = count + 1;
                }
            } else if (result is ErrorMsg) {
                io:println("Error: " + result.errmsg);
            } else {
                io:println("An error occurred while retrieving the programmes.");
            }
        } else if (choice == 7) {

            Programme[]|ErrorMsg|error result = getProgrammeByFaculty();

            if (result is Programme[]) {
                io:println("\n*** " + result.length().toString() + " programmes retrieved ***\n");
                int count = 1;

                foreach Programme programme in result {
                    io:println("Programme #" + count.toString() + "\n");
                    displayProgramme(programme);
                    count = count + 1;
                }
            } else if (result is ErrorMsg) {
                io:println("Error: " + result.errmsg);
            } else {
                io:println("An error occurred while retrieving the programmes.");
            }
        } else if (choice == 8) {
            io:println("\nExiting...");
            return;
        } else {
            io:println("\nInvalid option. Please try again.\n");
        }
    }
}

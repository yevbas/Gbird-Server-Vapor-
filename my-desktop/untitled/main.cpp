#include <iostream>
#include <fstream>
#include <string>
#include <map>

using namespace std;

int showError(string error_name);
int sayGoodbye();

int greet();
int showMenu();
int showDictionaries();
int chooseDictionary(int index);

int chooseDataOrigin();

int create_new_dictionary(string name);

int add_file_to_base(string name);

int main() {

    greet();

    showMenu();

    return 0;
}

int greet() {
    cout << "+-------------------------+" << endl;
    cout << "|   Welcome to Codility!  |" << endl;
    cout << "|   Press Enter to start  |" << endl;
    cout << "+-------------------------+";
    cin.get(); cout << string(20, '\n' );

    return 0;
}

int showMenu() {
    string file_name;
    char option;

    cout << "+---------------------------+" << endl;
    cout << "| 1. Choose dictionary.     |" << endl;
    cout << "| 2. Create new dictionary. |" << endl;
    cout << "| 3. Quit.                  |" << endl;
    cout << "+---------------------------+" << endl;
    cout << "~ option: "; cin >> option;

    switch (option) {
        case '1' :
            int dictionary_index;

            showDictionaries();

            cout << "+------------------------------+" << endl;
            cout << "|  Choose dictionary number:D  |" << endl;
            cout << "+------------------------------+" << endl;

            cin >> dictionary_index;

            chooseDictionary(dictionary_index);

            chooseDataOrigin();

            break;
        case '2' :
            cout << string(20, '\n' );
            cout << "+------------------------------+" << endl;
            cout << "|  Enter name for dictionary!  |" << endl;
            cout << "+------------------------------+" << endl;
            cout << "~ name: "; cin >> file_name;

            file_name = file_name + "_codility.txt";

            create_new_dictionary(file_name);

            break;
        case '3' :
            sayGoodbye();
            break;
        default:
            cout << string(20, '\n' );
            cout << "+----------------------+" << endl;
            cout << "|  Bad option chosen!  |" << endl;
            cout << "+----------------------+" << endl;
            break;
    };

    return 0;
};

int create_new_dictionary(string name) {
    int letter_count;

    switch (ifstream (name).good()) {
        case true:
            cout << string(20, '\n' );
            cout << "+---------------------------------------------+" << endl;
            cout << "|  Dictionary with this name already exists!  |" << endl;
            cout << "+---------------------------------------------+" << endl;

            showMenu();

            break;
        case false:
            ofstream file; file.open(name, std::ios_base::app);
            add_file_to_base(name);

            cout << string(20, '\n' );
            cout << "+--------------------------------------------------+" << endl;
            cout << "|  How many letters will contain your dictionary?  |" << endl;
            cout << "+--------------------------------------------------+" << endl;
            cout << "~ count: "; cin >> letter_count; cout << endl;

            if (file.is_open()) {
                for(int i = 0; i < letter_count; i++) {
                    string letter, code;

                    cout << "~ letter: "; cin >> letter;
                    cout << "~ code: "; cin >> code;
                    cout << endl;

                    file << letter << "->" << code << endl;
                }

                cout << "+----------------------------------------------------+" << endl;
                cout << "| Congratulations, your dictionary is ready to use ! |" << endl;
                cout << "+----------------------------------------------------+" << endl;

                file.close();

                showMenu();
            } else {
                showError("Can't open your dictionary yet");
            }

            break;
    };

    return  0;
};

int showError(string error_name) {
    cout << "[!!!] " << error_name << endl;
    return 0;
}

int showDictionaries() {
    ifstream file;
    file.open("dictionaries.txt");

    string line;

    int dictionary_index = 1;

    cout << string(20, '\n' );
    cout << "+--------" << endl;

    if (file.is_open()) {

        while(getline(file, line)) {

            cout << "| " << dictionary_index << ". " << line << "\n" ;

            dictionary_index++;
        }

        cout << "+--------" << endl;

    } else {
        showError("Can't open your dictionary yet");
    };

    return 0;
};

int chooseDictionary(int index) {
    return 0;
};

int chooseDataOrigin() {
    int option;

    cout << string(20, '\n' );
    cout << "+-------------------------------+" << endl;
    cout << "| 1. Choose file to encode.     |" << endl;
    cout << "| 2. Create new file to encode. |" << endl;
    cout << "| 3. Quit.                      |" << endl;
    cout << "+-------------------------------+" << endl;
    cin >> option;

    switch (option) {
        case 1:
            char file_name[50];

            cout << string(20, '\n' );
            cout << "+--------------------+" << endl;
            cout << "|  Enter file name!  |" << endl;
            cout << "+--------------------+" << endl;
            cout << "~ file name: "; cin >> file_name;

            // TODO: End flow..

            break;
        case 2:
            break;
        case 3:
            sayGoodbye();
            break;
        default:
            cout << string(20, '\n');
            cout << "+----------------------+" << endl;
            cout << "|  Bad option chosen!  |" << endl;
            cout << "+----------------------+" << endl;

            break;
    }

    return 0;
};

int sayGoodbye() {
    cout << string(20, '\n' );
    cout << "+----------------------------------+" << endl;
    cout << "|  Thanks for using our app, bye!  |" << endl;
    cout << "+----------------------------------+" << endl;

    return 0;
};

int add_file_to_base(string name) {
    ofstream dictionaries_file;

    dictionaries_file.open("dictionaries.txt", std::ios_base::app);
    dictionaries_file << name << endl;
    dictionaries_file.close();

    return 0;
};

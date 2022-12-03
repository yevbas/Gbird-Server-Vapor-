#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <map>
#include <vector>

using namespace std;

struct dictionaryElement {
    string key;
    string value;
};

int greet();
int show_menu();
int show_dictionaries_list();
int show_error(string error_name);
int say_goodbye();

string get_dictionary_name(int index);
vector<dictionaryElement> get_dictionary(string file);

int encode(string file, vector<dictionaryElement> dictionary, int dictionary_size);
int decode(string file, vector<dictionaryElement> dictionary, int dictionary_size);
string value(string forKey, vector<dictionaryElement> dictionaryElement, int dictionary_size);
string key(string forValue, vector<dictionaryElement> dictionary, int dictionary_size);

int choose_text_to_encode(vector<dictionaryElement> dictionary);
int create_new_dictionary();
int create_new_file();
int add_file_to_base(string name);

int main() {
    greet();
    show_menu();
    return 0;
}

int greet() {
    cout << "+-------------------------+" << endl;
    cout << "|   Welcome to Codility!  |" << endl;
    cout << "|   Press Enter to start  |" << endl;
    cout << "+-------------------------+";
    cin.get();
    return 0;
}
int say_goodbye() {
    cout << string(20, '\n' );
    cout << "+----------------------------------+" << endl;
    cout << "|  Thanks for using our app, bye!  |" << endl;
    cout << "+----------------------------------+" << endl;
    return 0;
};
int show_error(string error_name) {
    cout << "[!!!] " << error_name << endl;
    return 0;
}
int add_file_to_base(string name) {
    ofstream dictionaries_file;
    dictionaries_file.open("dictionaries.txt", std::ios_base::app);
    dictionaries_file << name << endl;
    dictionaries_file.close();
    return 0;
};
int show_dictionaries_list() {
    ifstream file("dictionaries.txt");
    string line;

    int i = 1;

    cout << string(20, '\n' );
    cout << "+--------" << endl;

    if (file.is_open()) {
        while(getline(file, line)) {
            cout << "|" << i << "." << line << "\n" ;
            i++;
        }
        cout << "+--------" << endl;
    } else {
        show_error("Can't open your dictionary yet");
    };

    return 0;
};


int show_menu() {
    string file_name, dict_name;
    vector<dictionaryElement> dictionary;
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

            show_dictionaries_list();
            cout << "+------------------------------+" << endl;
            cout << "|  Choose dictionary number:D  |" << endl;
            cout << "+------------------------------+" << endl;
            cout << "~ number: "; cin >> dictionary_index;

            dict_name = get_dictionary_name(dictionary_index - 1);
            dictionary = get_dictionary(dict_name);
            choose_text_to_encode(dictionary);

            break;
        case '2' :
            create_new_dictionary();
            break;
        case '3' :
            say_goodbye();
            break;
        default:
            show_error("Bad option chosen!");
            break;
    };

    return 0;
};

int create_new_dictionary() {
    string file_name;
    int letter_count;

    cout << string(20, '\n' );
    cout << "+------------------------------+" << endl;
    cout << "|  Enter name for dictionary!  |" << endl;
    cout << "+------------------------------+" << endl;
    cout << "~ name: "; cin >> file_name;

    file_name += "_codility.txt";

    switch (ifstream(file_name).good()) {
        case true:
            cout << string(20, '\n' );
            cout << "+---------------------------------------------+" << endl;
            cout << "|  Dictionary with this name already exists!  |" << endl;
            cout << "+---------------------------------------------+" << endl;
            show_menu();
            break;
        case false:
            ofstream file; file.open(file_name, std::ios_base::app);
            add_file_to_base(file_name);

            cout << string(20, '\n' );
            cout << "+--------------------------------------------------+" << endl;
            cout << "|  How many letters will contain your dictionary?  |" << endl;
            cout << "+--------------------------------------------------+" << endl;
            cout << "~ count: "; cin >> letter_count; cout << endl;

            if (file.is_open()) {
                for(int i = 0; i < letter_count; i++) {
                    string letter, code;
                    cout << "~ letter(" << i << "): "; cin >> letter;
                    cout << "~ code for letter " << letter << " :" ; cin >> code;
                    cout << endl;
                    file << letter << "~" << code << endl;
                }

                cout << "+----------------------------------------------------+" << endl;
                cout << "| Congratulations, your dictionary is ready to use ! |" << endl;
                cout << "+----------------------------------------------------+" << endl;

                file.close();

                show_menu();
            } else {
                show_error("Can't open your dictionary yet");
            }

            break;
    };

    return  0;
};

string get_dictionary_name(int index) {
    ifstream file("dictionaries.txt");
    string line;

    int i = 0;

    if (file.is_open()) {
        while (i != index + 1) {
            getline(file, line);
            i++;
        };
    } else {
        show_error("Can't open your dictionary yet");
    };

    return line;
};

vector<dictionaryElement> get_dictionary(string file) {
    vector<dictionaryElement> dictionary;

    ifstream dictionary_file(file);

    string current_string;

    if (dictionary_file.is_open()) {
        while (dictionary_file.good()) {
            getline(dictionary_file, current_string);
            dictionaryElement element;
            element.key = current_string.substr(0, current_string.find('~'));
            element.value = current_string.substr(current_string.find('~') + 1, current_string.find('\0'));
            dictionary.push_back(element);
        };
    } else {
        show_error("Can not open the file");
    };

    dictionary_file.close();
    return dictionary;
};

int choose_text_to_encode(vector<dictionaryElement> dictionary) {
    int option;
    string file_name;
    ifstream input_file;

    cout << string(20, '\n' );
    cout << "+-------------------------------+" << endl;
    cout << "| 1. Choose file to encode.     |" << endl;
    cout << "| 2. Create new file to encode. |" << endl;
    cout << "| 3. Choose file to decode.     |" << endl;
    cout << "| 4. Quit.                      |" << endl;
    cout << "+-------------------------------+" << endl;
    cin >> option;

    switch (option) {
        case 1:
            cout << string(20, '\n' );
            cout << "+--------------------+" << endl;
            cout << "|  Enter file name!  |" << endl;
            cout << "+--------------------+" << endl;
            cout << "~ file name: "; cin >> file_name;

            input_file.open(file_name + ".txt");

            if (input_file.is_open()) {
                encode(file_name, dictionary, dictionary.size());
                show_menu();
            } else {
                show_error("No file with provided name!");
                choose_text_to_encode(dictionary);
            }
            break;
        case 2:
            create_new_file();
            choose_text_to_encode(dictionary);
            break;
        case 3:
            cout << string(20, '\n' );
            cout << "+--------------------+" << endl;
            cout << "|  Enter file name!  |" << endl;
            cout << "+--------------------+" << endl;
            cout << "~ file name: "; cin >> file_name;

            decode(file_name, dictionary, dictionary.size());

            show_menu();
            break;
        case 4:
            say_goodbye();
            break;
        default:
            show_error("Bad option chosen!");
            choose_text_to_encode(dictionary);
            break;
    }

    return 0;
};

int create_new_file() {
    ofstream file;
    string file_name, text;

    cout << string(20, '\n' );
    cout << "+------------------------------------------------+" << endl;
    cout << "|  Enter name of the file without of any ext :D  |" << endl;
    cout << "+------------------------------------------------+" << endl;
    cout << "~ File name: "; cin >> file_name;

    file.open(file_name + ".txt");

    if (file.is_open()) {
        cout << string(20, '\n' );
        cout << "+------------------------------------+" << endl;
        cout << "|  Enter message you want to encode  |" << endl;
        cout << "+------------------------------------+" << endl;
        cout << "~ Text: "; cin >> text;

        file << text;
        file.close();
    } else {
        show_error("[!!!] Can not create a file!");
    };
    return 0;
};

int decode(string file, vector<dictionaryElement> dictionary, int dictionary_size) {
    ifstream input_file(file + "_encoded" + ".txt");
    ofstream output_file(file + "_decoded" + ".txt");

    cout << string(20, '\n' );
    cout << "+---------------------+" << endl;
    cout << "|  Start decoding...  |" << endl;
    cout << "+---------------------+" << endl;

    char c;
    string value;
    while (input_file.get(c)) {
        if (c == '$') {
            output_file << ' ';
        } else if (c == '\0') {
            output_file << "\n";
        } else if (c == '+') {
            output_file << key(value, dictionary, dictionary_size);
            value = "";
        } else {
            value += c;
        };
    };

    input_file.close();
    output_file.close();

    cout << string(20, '\n' );
    cout << "+-------------------------------+" << endl;
    cout << "|  Decoding finished /_(^~^)_/  |" << endl;
    cout << "+-------------------------------+" << endl;

    return 0;
};

int encode(string file, vector<dictionaryElement> dictionary, int dictionary_size) {
    ifstream input_file(file + ".txt");
    ofstream output_file(file + "_encoded" + ".txt");

    cout << string(20, '\n' );
    cout << "+---------------------+" << endl;
    cout << "|  Start encoding...  |" << endl;
    cout << "+---------------------+" << endl;

    char c;
    while (input_file.get(c)) {
        if (c == ' ') {
            output_file << "$";
        } else if (c == '\0') {
            output_file << "\n";
        } else {
            string key(1, c);
            output_file << value(key, dictionary, dictionary_size);
            output_file << "+";
        };
    };

    input_file.close();
    output_file.close();

    cout << string(20, '\n' );
    cout << "+-------------------------------+" << endl;
    cout << "|  Encoding finished /_(^~^)_/  |" << endl;
    cout << "+-------------------------------+" << endl;

    return 0;
};

string key(string forValue, vector<dictionaryElement> dictionary, int dictionary_size) {
    for(int i = 0; i <= dictionary_size; i++) {
        dictionaryElement element = dictionary[i];
        if (element.value == forValue) {
            return element.key;
        }
    };
    return forValue;
};

string value(string forKey, vector<dictionaryElement> dictionary, int dictionary_size) {
    for(int i = 0; i <= dictionary_size; i++) {
        dictionaryElement element = dictionary[i];
        if (element.key == forKey) {
            return element.value;
        }
    };
    return forKey;
};
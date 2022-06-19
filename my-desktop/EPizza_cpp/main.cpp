#include <iostream>
#include <string>
#include <fstream>


using namespace std;

struct Position {
    int type;
    int position;

    Position(int type, int position) {
        this->type = type;
        this->position = position;
    }
};

struct PositionNode {
public:
    Position position_value;
    PositionNode *next_position ;
};

void print_list(PositionNode * head) {
    PositionNode * current = head;

    while (current != nullptr) {
        cout << current->position_value.type << " ";
        current = current->next_position;
    }
}

void push(PositionNode * lastPosition, Position position) {
    PositionNode * current = lastPosition;
    while (current->next_position != nullptr) current = current->next_position;
    current->next_position = (PositionNode*) malloc(sizeof (PositionNode));
    current->next_position->position_value = position;
    current->next_position->next_position = nullptr;
}

// ==========

enum TypeOfFood: int {
    Pizza = 0, Drinks = 1
};

enum Pizza: int {
    Pepperoni = 0, DoubleCheese = 1, TomatoCombat = 2
};

enum Drinks: int {
    Coke = 0, Pepsi = 1, OrangeJuice = 2
};

// ==========

struct Order {
    string name;
    string address;
    string client_mobile;
    PositionNode* position;
};

// ==========

void addPosition(int type, Order& order);
void chooseTypeOfFood(Order& order);
void saveOnFile(Order& order);

void createOrder(Order& order) {

    cout << "|> Welcome! Let's crete an order !" << endl;

    cout << "|> What's your name ? "; cin >> order.name;
    cout << "| -------------- \n";
    cout << "|> What's your address ? "; cin >> order.address;
    cout << "| -------------- \n";
    cout << "|> What's your phone number ? "; cin >> order.client_mobile;

    cout << "| -------------- \n";
    cout << "| :D " << order.name << ", let's start ! \n";
    cout << "| -------------- \n";

    chooseTypeOfFood(order);
};

void chooseTypeOfFood(Order& order) {
    int type = -1;

    cout << "| 0. Pizza" << endl;
    cout << "| 1. Drinks" << endl;
    cout << "|-------------- \n";
    cout << "|> Choose section (enter number): "; cin >> type;
    cout << "|-------------- \n\n";

    addPosition(type, order);
};

void addPosition(int type, Order& order) {
    int pos = -1;

    cout << "| ------| Positions |-------- |\n";

    switch (type) {

        case Pizza:
            cout << "| 0. Pepperoni \n";
            cout << "| 1. Double-cheese \n";
            cout << "| 2. Tomato-combat \n";
            break;

        case Drinks:
            cout << "| 0. Coke \n";
            cout << "| 1. Pepsi \n";
            cout << "| 2. OrangeJuice \n";
            break;

        default: break;
    }
    cout << "\n|> Choose position_value (enter number): "; cin >> pos;

    // add to list.
    push(order.position, Position(type, pos));

    cout << "| =) good choice ! \n\n";

    int nextAction = -1;

    cout << "| -----| What will we do next_position ? |-------- |\n";
    cout << "| 0. Add more positions ! \n";
    cout << "| 1. End creating :) \n";
    cout << "| -------------- \n\n";

    cout << "|> Choose: ";

    cin >> nextAction;

    switch (nextAction) {
        case 0:
            chooseTypeOfFood(order);
            break;
        case 1:

            saveOnFile(order);

            cout << "| -------------- \n";
            cout << "\n\n"
                    "| Nice order!!! \n"
                    "| Thanks for being with us :)\n"
                    "| We will order it to you in 30 min";
            cout << "| -------------- \n";
            break;
    }
}

void saveOnFile(Order& order) {

    PositionNode* current = order.position;
    ofstream orderFile;
    orderFile.open ("order_5.txt");

    orderFile << "{\n";
    orderFile << "order_id: 1" << endl;
    orderFile << "client_name: " << order.name << endl;
    orderFile << "client_phone: " << order.client_mobile << endl;
    orderFile << "address: " << order.address << endl;
    orderFile << "positions: \n   [ " << endl;

    while (current != nullptr) {
        orderFile   << "    - Section: " << current->position_value.type << endl
                    << "    - Position_name: " << current->position_value.position << endl << endl << endl;

        current = current->next_position;
    }

    orderFile <<    "]\n";
    orderFile << "}";

    cout << "| Order information wrote to file successfully !";

    orderFile.close();
};

int main() {

    Order order = Order();

    order.position = (PositionNode*) malloc(sizeof (PositionNode));

    createOrder(order);

    delete order.position;

    return 0;
}
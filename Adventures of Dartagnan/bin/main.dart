// The adventures of D'Artagnan
//
// Name: Ethan Wolcott
// Purpose: Practice all concepts learned...
// Sources: https://www.tutorialspoint.com/dart_programming/index.htm
// Sources: https://stackoverflow.com/questions/55007696/how-to-get-console-integer-input-from-user-in-a-dart-program
//
import 'dart:io';

class Person {
  String name; // Who am I?
  String location; // Where am I?
  List knapSack; // What do I own?
  double health = 100.0; // Initially 100.0

  // Default constructor for a Person
  // Syntax below automatically initializes member variables!
  Person(this.name, this.location, this.knapSack);

  // Convert Person to a String
  String toString() {
    String str;
    str = "Peasant: $name, $location, $knapSack, $health";
    return str;
  }
}

class Knight extends Person implements SpellCaster {
  // Must provide a list of spells as required by the interface
  List spells;

  // construct a Knight and call the superclass constructor
  Knight(this.spells, String name, String location, List knapSack)
      : super(name, location, knapSack);

  // create a Knight from an existing Person object
  Knight.fromPerson(this.spells, Person pawn)
      : super(pawn.name, pawn.location, pawn.knapSack);

  // Convert Knight to a String
  String toString() {
    String str;
    str = "Knight: $name, $location, $knapSack, $health, $spells";
    return str;
  }

  // The Knight must provide castSpell
  // because it implements the SpellCaster interface
  // only allow user to cast spells in the
  // spells list.
  castSpell() {
    print("What spell would you like to cast?");
    print(spells);
    String choice = stdin.readLineSync();
    if (spells.contains(choice)) {
      print("You cast the $choice spell!");
    } else {
      print("You are not allowed to cast spell $choice");
    }
  }
}

class Wizard extends Person implements SpellCaster {
  // Must provide a list of spells as required by the interface
  List spells;

  // construct a Knight and call the superclass constructor
  Wizard(this.spells, String name, String location, List knapSack)
      : super(name, location, knapSack);

  // create a Knight from an existing Person object
  Wizard.fromPerson(this.spells, Person pawn)
      : super(pawn.name, pawn.location, pawn.knapSack);

  // Convert Knight to a String
  String toString() {
    String str;
    str = "Wizard: $name, $location, $knapSack, $health, $spells";
    return str;
  }

  // The Wizard must provide castSpell
  // because it implements the SpellCaster interface
  // only allow user to cast spells in the
  // spells list.
  castSpell() {
    print("What spell would you like to cast?");
    print(spells);
    String choice = stdin.readLineSync();
    if (spells.contains(choice)) {
      print("You cast the $choice spell!");
    } else {
      print("You are not allowed to cast spell $choice");
    }
  }
}

// Define the SpellCaster interface class
// You can't make an object directly from an
// abstract class.
abstract class SpellCaster {
  List spells; // What spells can I cast?

  // SpellCasters must provide a
  // castSpell() method
  castSpell();
}

// An enumeration of actions that a user can choose
enum Action {
  drink,
  eat,
  cast_spell,
  drop,
  pickup,
  use_potion,
  fast_travel,
  personal_info,
  quit
}

//record options for character selection
enum Types { Knight, Wizard, Peasant } 

// Convert a string to an Action (or return null if it can't convert)
// original source: https://stackoverflow.com/questions/27673781/enum-from-string
Action getActionFromString(String action) {
  var str = 'Action.$action';
  return Action.values
      .firstWhere((e) => e.toString() == str, orElse: () => null);
}

// Global inventory
var inventory = ["Food", "Water Bottle", "Potions"]; 

Action chooseAction() { //prints out enum of actions and reads in the written choice
  // Enter a string from a user then convert the string to an Action
  // enumeration type variable. Force user to pick a valid action
  Action act;
  do {
    print("What action do you choose from the following options?");
    List str_actions =
        Action.values.map((e) => e.toString().split('.')[1]).toList();
    print(str_actions);
    String choice = stdin.readLineSync();
    act = getActionFromString(choice);
  } while (act == null);
  return act;
}

// Execute chosen action
int nextState(Action act, Person chartype) {
  // Logic to determine the next state of the player
  // and output effects of choices
  switch (act) {
    // Game Control Action quit
    case Action.quit:
      {
        return 0; // Stop the game
      }
    // Actions not yet implemented
    case Action.drink: //drink the water bottle and remove from inventory
      if (inventory.remove("Water Bottle")) {
        print('Glug glug. Yum yum.');
        inventory.remove('Water Bottle');
      }
      else print('There is nothing with which to quench your insatiable thirst.');
      return 1;
    case Action.eat: //eat the food and remove from inventory
      if (inventory.remove("Food")) {
        print('Delicious');
        inventory.remove('Food');
      }
      else print('Guess you have to starve.');
      return 1;
    case Action.drop: //discard an item from inventory into the map
      return 3;//
    case Action.pickup: //add an item from the location into your inventory
      return 2;
    case Action.personal_info: //display personal stats
      print(chartype.toString());
      break;
    case Action.fast_travel: //travel through the map
      return 4;
    case Action.use_potion: //engage in sorcery via brew
      return 6;
    case Action.cast_spell: //engage in sorcery via incantation
      return 5;
  }
  return 1;
}

//play that game!
main() {
  // Welcome to the adventure game
  print("Welcome to Dart World!");
  bool playing = true; //the game plays
  int selection = 1; //entry to loop point
  String location = "Village"; //establish spawn point
  String choice;

  var items = Map(); //locations to travel between with their respective items
  items["Forest"] = ["dragon", "potion", "gingerbread"];
  items["Mountain"] = ["rock", "arrowhead"];
  items["Village"] = ["ring", "food", "money"];
  items["Lake"] = ["sword", "fish", "boat"];
  items["Shop"] = ["cloak", "dagger", "shield"];

  var graph = {
    // Key : Connected Locations
    "Forest": ["Mountain", "Village"],
    "Mountain": ["Forest", "Lake", "Village"],
    "Lake": ["Mountain"],
    "Village": ["Forest", "Shop", "Mountain"],
    "Shop": ["Village"]
  };

  String p1; //stores input
  var player; //stores class of character

  //construct a character of choice
  print('Who do you fancy playing as?');
  List str_actions =
      Types.values.map((e) => e.toString().split('.')[1]).toList();
  print(str_actions);
  p1 = stdin.readLineSync();
  if (p1 == "Knight") {
    player =
        Knight(["ramparts", "heal"], "Charles", "Forest", ["drill", "hammer"]);
  } else if (p1 == "Wizard") {
    player = Wizard(
        ["lightning", "wisdom"], "Charles", "Forest", ["staff", "cloak"]);
  } else if (p1 == "Peasant") {
    player = Person("Finnagan", "Village", ["medicine", "moleskin"]);
  }

  print(player.toString());

  while (playing) { //loop through commands
    var action = chooseAction();
    selection = nextState(action, player);
    if (selection == 0) {
      playing = false;
    }

    if (selection == 2) { //add itmes to your inventory
      print('You are in the $location.');
      print(" ");
      print("Looking around, you see the following items: ");
      print(items[location]);
      print('What would you like to pick up?');
      choice = stdin.readLineSync();
      //only add to inventory if choice can be removede from list
      if (items[location].remove(choice)) {
        inventory.add(choice);
      }
    }

    if (selection == 3) { //discard into items of location
      print('What would you like to drop in the $location?');
      print(inventory);
      choice = stdin.readLineSync();
      //only add to inventory if choice can be removed from list
      if (inventory.remove(choice)) {
        items[location].add(choice);
      }
    }

    if (selection == 4) { //fast travel prompts
      print("Where would you like to go?");
      var menu = new List();
      menu.addAll(graph[location]);
      menu.addAll(["display", "quit"]);
      print(menu);

      // Get the users choice
      choice = stdin.readLineSync();
      print(" ");
      if (choice == "display") {
        print("The items in this location are: ");
        print(items[location]);
      } else if (graph[location].contains(choice)) {
        // You can only go to your choice location
        // if your choice exists in the graph[location]
        location = choice;
      }
    }

    if (selection == 5) { //use potions
      if (p1 == 'Knight') {
        player.castSpell();
      } else if (p1 == 'Wizard') {
        player.castSpell();
      } else //peasants are muggles
        print('You have no magic powers. Wahmp wahmp.');
    }

    if (selection == 6) { //use potions
      if (p1 == 'Knight') {
        print('POOF! Ah schucks, guess it was a dud.');
        inventory.remove('Potion');
      } else if (p1 == 'Wizard') {
        print('POOF! Ah schucks, guess it was a dud.');
        inventory.remove('Potion');
      } else //Peasants are muggles
        print('You have no no understanding of potions. Wahmp wahmp.');
    }
  }
  print('Toodles!'); //end game
}

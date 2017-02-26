/*
 * A generic class for creating & managing ArrayLists
 * Generics or paramterized types can be used with any data type.
 * SOFT used for Fête du Code Pompidou March 2017
 */

//////////////////////////////////////////////////
import java.util.*;

class PT_ArrayList<Item> {

  private Item DATA_TYPE;
  ArrayList<Item> COLLECTION;


  public PT_ArrayList() {
    COLLECTION = new ArrayList<Item>();
  }


  public void addItem(Item _item) {
    COLLECTION.add(_item);
    this.DATA_TYPE=_item;
  }

  public Item getItem(int _index) {
    Item i = COLLECTION.get(_index);
    return i;
  }

  public void printOut() {
    for (Item i : COLLECTION) {
      println("Array contents : "+ i);
    }
  }

  public void clearData() {
    COLLECTION.clear();
  }

  /*
   * Method for getting size
   */
  public int getSize() {
    int s = COLLECTION.size();
    return s;
  }

  /*
   * Implements Iterator for grabbing content
   */
  void getAll() {
    Iterator itr = COLLECTION.iterator();
    while (itr.hasNext ()) {
      Object element = itr.next();
      print(element + " ");
    }
  }


  /*
   * Modifiy contents of Collection
   */

  void modify() {
    ListIterator litr = COLLECTION.listIterator();
    while (litr.hasNext ()) {
      Object element = litr.next();
      litr.set(element + "added this");
    }
  }

  /*
   * Method for returning data type
   */
  String getDataType() {
    String s = DATA_TYPE.getClass().getName();
    return s;
  }

  /*
   * Method for removing duplicates of Integer/Float type
   * Handy when we need to strip down data for sending to SAM
   */

  public int removeDups() {

    int size = COLLECTION.size();
    int duplicates = 0;

    for (int i = 0; i < size - 1; i++) {
      // start from the next item
      // since the ones before are checked
      for (int j = i + 1; j < size; j++) {

        if (COLLECTION.get(j)!=(COLLECTION.get(i)))
          //if (!COLLECTION.get(j).equals(COLLECTION.get(i))) // >>> String check implementation
          continue;
        duplicates++;
        COLLECTION.remove(j);
        // decrease j because the array got re-indexed
        j--;
        // decrease the size of the array
        size--;
      } // for j
    } // for i

    return duplicates;
  }
}

///////////////////////////////////////// COLLECTION END

/*
 * Nice general purpose class for collecting & retrieving Strings by ID
 * - Good for messages.
 * NOTE : Each message must by given a separate ID !
 */

import java.util.Map;

public class Hash {

  HashMap<String, String> HASH_COLLECTION;


  public Hash() {
    HASH_COLLECTION = new HashMap<String, String>();
  }

  /*
   * Method for adding messages with an ID/Key
   */
  public void addMessage(String _id, String _msg) {
    HASH_COLLECTION.put(_id, _msg);
  }

  /*
   * Method for getting a message from Collection by id/key
   * @param  id  : index of String to return in Collection
   */
  public String getMessage(String _id) {
    String s = HASH_COLLECTION.get(_id);
    return s;
  }

  /*
   * Method for displaying last Hash entry in console
   */
  public void printOutHashEntries() {
    println("······················· HASH ·······················");
    for (Map.Entry em : HASH_COLLECTION.entrySet () ) {
      println("ID: "+em.getKey()+" | Message: "+em.getValue());
    }
    println("···················································· HASH END");
  }

   /*
   * Method for returning last Hash entry as a String
   */
  public String returnHashEntries() {
    String out = "";
    out+="················ HASH ················\n";
    for (Map.Entry em : HASH_COLLECTION.entrySet () ) {
      //println("ID: "+em.getKey()+" | Message: "+em.getValue());
      out+= "ID: "+em.getKey()+"\n";
      out+= "Message: "+em.getValue() + "\n";
    }
     out+="···························· END\n";
     return out;
  }
}

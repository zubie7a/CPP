/*Santiago Zubieta*/
#include <iostream>
#include <numeric>
#include <fstream>
#include <climits>
#include <cstring>
#include <cstdio>
#include <cmath>
#include <queue>
#include <list>
#include <map>
#include <set>
#include <stack>
#include <deque>
#include <vector>
#include <string>
#include <cstdlib>
#include <cassert>
#include <sstream>
#include <iterator>
#include <algorithm>  

#define MAXN 721

using namespace std;

int arr[100000];
bool DEBUG = false;

unsigned int mergeCount(int a, int b) {
    if(a == b){
    // In case its just a single element there will be no inversions
        return 0;
    }
    int half = (a + b) / 2;
    // Find the mid position between the current left and right indices
    unsigned int invs1 = 0;
    unsigned int invs2 = 0;
    // the number of inversions of the left side, and of the right side
    // then the number of crossing inversions will be calculated later.
    invs1 = mergeCount(a, half);
    // From first index value until floor(mid point)
    invs2 = mergeCount(half + 1, b);
    // From ceiling(mid point) to last index value
    int lena = (half - a) + 1;
    // Length of the left part
    int lenb = (b - (half + 1)) + 1;
    // Length of the right part
    int len = (b - a) + 1;
    // Length of the whole thing
    int result[len];
    // Where the sorted numbers are going to be storaged, afterwards,
    // they'll be put back into the original array in the new order.
    int i = 0, j = 0;
    // Index values for both sides values which will increase accordingly
    // when one value from either side is put into the resulting array.
    int invs = 0;
    // For storing the number of cross inversions in the whole thing
    int left, right;
    // For storing the current lowest value from each of the arrays
    for(int k = 0; k < len; k++) {
        left =  (i < lena)? arr[a + i]        : 1 << 30;
        right = (j < lenb)? arr[half + 1 + j] : 1 << 30;
        // When either of the arrays is exhausted, there's no number to
        // compare with, so we create a sufficiently large number so all
        // comparissons default to being lower than such a number.
        if(left < right) {
        // If the current left-side value is lower than the current right one
            result[k] = left;
            i++;
        }
        else {
        // If the current right-side value is lower than the current left one
            result[k] = right;
            invs += lena - i;
            // In addition, add the remaining left-side values to the number
            // of inversions, because all those are bigger than this value.
            j++;
        }
    }
    for(int k = 0; k < len; k++) {
        arr[a + k] = result[k];
        // Put back the newly ordered values into the original array
    }
    return invs + invs1 + invs2;
    // Return the number of cross inversions, and the inversions of each array
}

void debugNumbers() {
// These are numbers generated by default just to test, in decreasing order
// from 721 to 1. This allows us to test that a reversed sorted array, will
// have a number of inversions equal to (n * (n - 1)) / 2, or 259560.
    for(int i = 0; i < MAXN; i++){
        arr[i] = MAXN - i;
    }
}

int main() {
    int i;
    if(DEBUG) {
        debugNumbers();
        i = MAXN;
    } 
    else {
        int n;
        i = 0;
        // Try running with the given file input
        // ./MergeCount < IntegerArray.txt
        while(cin >> n) {
            arr[i++] = n;
        }
    }
    unsigned int invs = mergeCount(0, i - 1);
    // The number can be really big, and will never be negative, so its better
    // to use an unsigned integer, to have more storage space for it!
    cout << "Inversions: " << invs << endl;
}
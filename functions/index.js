const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.capitalizeCity = functions.firestore
.document('cities/{cityRefId}')
.onCreate((citySnapshot, context) => {
          const cityRefID = context.params.cityRefId;
          
          const newCityRef = admin.firestore().collection('cities').doc(cityRefID);
          const newCity = new Promise(
                                      function(resolve, reject) {
                                      newCityRef.get()
                                      .then(newCitySnapshot => {
                                            if (!newCitySnapshot.exists) {
                                            reject(new Error('No such document!'));
                                            return
                                            } else {
                                            resolve(newCitySnapshot.data().name);
                                            return
                                            }
                                            })
                                      .catch(err => {
                                            console.log('Error getting city', err);
                                            reject(err);
                                            });
                                      });
          return Promise.all([newCity])
          .then(results => {
                const newName = results[0];
                
                const uppercasingName = admin.firestore().collection('citiesCapitalized').doc();
                const setUppercasingName = uppercasingName.set({refID: uppercasingName.id,
                                                             name: newName.toUpperCase()});
                return
                })
          });

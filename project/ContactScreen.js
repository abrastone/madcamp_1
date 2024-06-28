import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  StyleSheet,
  PermissionsAndroid,
  FlatList,
} from 'react-native';
import Contacts from 'react-native-contacts';

const ContactScreen = () => {
  const [contacts, setContacts] = useState([]);

  useEffect(() => {
    requestContactsPermission();
  }, []);

  const requestContactsPermission = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.READ_CONTACTS,
        {
          title: '연락처 권한 요청',
          message: '연락처를 가져오기 위해 권한이 필요합니다.',
          buttonNeutral: '나중에 묻지 않기',
          buttonNegative: '거부',
          buttonPositive: '허용',
        },
      );
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        console.log('연락처 권한이 허용되었습니다.');
        loadContacts();
      } else {
        console.log('연락처 권한이 거부되었습니다.');
      }
    } catch (err) {
      console.warn(err);
    }
  };

  const loadContacts = () => {
    Contacts.getAll()
      .then(contacts => {
        setContacts(contacts);
      })
      .catch(err => {
        console.warn(err);
      });
  };

  const renderContact = ({item}) => (
    <View style={styles.contactContainer}>
      <Text style={styles.contactName}>{item.displayName}</Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.text}>Welcome to the Contact!</Text>
      <FlatList
        data={contacts}
        keyExtractor={item => item.recordID}
        renderItem={renderContact}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 24,
  },
  contactContainer: {
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  contactName: {
    fontSize: 18,
  },
});

export default ContactScreen;

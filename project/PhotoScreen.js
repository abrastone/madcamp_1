import React, {useState} from 'react';
import {View, Button, Image, StyleSheet} from 'react-native';
import {launchImageLibrary, launchCamera} from 'react-native-image-picker';
import RNFS from 'react-native-fs';

const PhotoScreen = () => {
  const [photoUri, setPhotoUri] = useState(null);

  const handleSelectPhoto = () => {
    launchImageLibrary({mediaType: 'photo'}, response => {
      if (response.didCancel) {
        console.log('User cancelled image picker');
      } else if (response.errorCode) {
        console.log('ImagePicker Error: ', response.errorMessage);
      } else {
        const source = response.assets[0].uri;
        setPhotoUri(source);
        savePhoto(source);
      }
    });
  };

  const savePhoto = async uri => {
    const fileName = uri.split('/').pop();
    const destPath = `${RNFS.DocumentDirectoryPath}/${fileName}`;

    try {
      await RNFS.copyFile(uri, destPath);
      console.log('Photo saved to:', destPath);
    } catch (error) {
      console.log('Error saving photo:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Button title="Select Photo" onPress={handleSelectPhoto} />
      {photoUri && <Image source={{uri: photoUri}} style={styles.image} />}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  image: {
    width: 300,
    height: 300,
    marginTop: 20,
  },
});

export default PhotoScreen;

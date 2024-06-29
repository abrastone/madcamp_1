import React, {useState, useEffect} from 'react';
import {View, Text, StyleSheet, Image} from 'react-native';
import poster from './assets/img/kokmin.jpg';
import data from './data/contest.json';

const HomeScreen = () => {
  const [cardData, setCardData] = useState({});

  useEffect(() => {
    setCardData(data);
  }, []);

  return (
    <View style={styles.container}>
      <View style={styles.card}>
        <Image source={poster} style={styles.image} />
        <View style={styles.textContainer}>
          <Text style={styles.title}>한국대학생 프로그래밍 경시대회</Text>
          <Text style={styles.description}>일정: 2025.10.12</Text>
          <Text style={styles.description}>모집: 출제(5) / 검수(0)</Text>
          <Text style={styles.description}>난이도: 브론즈 - 골드</Text>
          <Text style={styles.description}>more...</Text>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    alignItems: 'center',
  },
  textContainer: {
    flexDirection: 'column',
    marginLeft: 10,
    padding: 10,
  },
  card: {
    width: 350,
    height: 150,
    marginTop: 20,
    borderRadius: 20,
    backgroundColor: '#DDF1FF',
    flexDirection: 'row',
  },
  title: {
    fontSize: 14,
    marginTop: 20,
    marginBottom: 10,
    fontWeight: 'bold',
  },
  description: {
    fontSize: 10,
  },
  image: {
    width: 120,
    height: 120,
    borderRadius: 100,
    marginTop: 13,
    marginLeft: 10,
    backgroundColor: '#FFFFFF',
    borderWidth: 3,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 6,
    },
    shadowOpacity: 0.37,
    shadowRadius: 7.49,
  },
});

export default HomeScreen;

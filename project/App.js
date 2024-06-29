import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import HomeScreen from './HomeScreen';
import ContactScreen from './ContactScreen';
import {StyleSheet, Image} from 'react-native';
import HomeIcon from './assets/img/trophy.png';
import ContactIcon from './assets/img/phone.png';

const Tab = createBottomTabNavigator();

const App = () => {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({route}) => ({
          tabBarIcon: ({color, size}) => {
            let iconSource;
            if (route.name === '대회 정보') {
              iconSource = HomeIcon;
            } else if (route.name === '연락처') {
              iconSource = ContactIcon;
            }
            return (
              <Image
                source={iconSource}
                style={[
                  styles.icon,
                  {tintColor: color, width: size, height: size},
                ]}
              />
            );
          },
          tabBarStyle: styles.tabBar,
          tabBarLabelStyle: styles.tabBarLabel,
        })}>
        <Tab.Screen name="연락처" component={ContactScreen} />
        <Tab.Screen name="대회 정보" component={HomeScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
};

const styles = StyleSheet.create({
  tabBar: {
    backgroundColor: '#B0DBFA',
    borderTopWidth: 1,
    borderTopColor: '#ddd',
    height: 60,
  },
  tabBarLabel: {
    fontSize: 12,
    paddingBottom: 5,
  },
  icon: {
    width: 24,
    height: 24,
  },
});

export default App;

// @generated: @expo/next-adapter@2.1.54
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

interface Test {
  a: string;
}

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Works! 👋</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 16,
  },
});

import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {
  const fechaActual = new Date().toLocaleString();

  
  return (
    <div className="App">
      <header className="App-header">
        <p>201901758</p>
        <p>Erick Ivan Mayorga Rodriguez</p>
        <p>Hora y Fecha Actual: {fechaActual}</p>
      </header>
    </div>
  );
}

export default App

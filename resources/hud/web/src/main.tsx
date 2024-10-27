import { CssBaseline, StyledEngineProvider, ThemeProvider } from '@mui/material';
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './containers/App/App.tsx';
import './index.css';
import { DataProvider } from './providers/DataProvider';
import { VisibilityProvider } from './providers/VisibilityProvider';
import muiTheme from './theme';

createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <DataProvider>
      <VisibilityProvider>
        <StyledEngineProvider>
          <ThemeProvider theme={muiTheme}>
            <CssBaseline />
            <App />
          </ThemeProvider>
        </StyledEngineProvider>
      </VisibilityProvider>
    </DataProvider>
  </React.StrictMode>,
);

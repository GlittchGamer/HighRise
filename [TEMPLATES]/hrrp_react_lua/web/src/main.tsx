import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './containers/App/App.tsx';
import './index.css';
import { CssBaseline, StyledEngineProvider, ThemeProvider } from '@mui/material';
import muiTheme from './theme';
import { DataProvider } from './providers/DataProvider';
import { VisibilityProvider } from './providers/VisibilityProvider';

createRoot(document.getElementById('root')!).render(
  <DataProvider>
    <VisibilityProvider>
      <StyledEngineProvider>
        <ThemeProvider theme={muiTheme}>
          <CssBaseline />
          <App />
        </ThemeProvider>
      </StyledEngineProvider>
    </VisibilityProvider>
  </DataProvider>,
);

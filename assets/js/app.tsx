// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
const css = require('../css/app.css')

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import React from "react"
import ReactDOM from "react-dom"
import { Theme, injectGlobalStyles, Box, Flex } from "@artsy/palette"
import { Route, Switch, Router } from "react-router"
import { createBrowserHistory } from "history"
import {Main} from "./pages/main"
import {PlaceDetail} from "./pages/placeDetail";

import ApolloClient from "apollo-client"
import { setContext } from 'apollo-link-context'
import { ApolloProvider } from "react-apollo"
import { ApolloProvider as ApolloProviderHooks } from '@apollo/react-hooks'
import AuthService from "./services/authService"
import { InMemoryCache } from 'apollo-cache-inmemory'
import { Me } from "./pages/me";
import { createLink } from "apollo-absinthe-upload-link"
import Header from "./components/header"

const httpLink = createLink({
  uri: '/api',
});

const authLink = setContext((_, { headers }) => {
  // get the authentication token from local storage if it exists
  const token = (new AuthService).getToken()
  // return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      ...(token && {authorization: `Bearer ${token}`}),
    }
  }
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
})

const customHistory = createBrowserHistory()

const { GlobalStyles } = injectGlobalStyles()
class App extends React.Component {
  render() {
    return (
      <ApolloProvider client={client}>
        <ApolloProviderHooks client={client}>
          <Theme style={{width: "100%"}}>
            <GlobalStyles />
            <Router history={customHistory}>
              <Flex flexDirection="column" m={2}>
                <Header/>
                <Switch>
                  <Route path="/places/:placeId" component={PlaceDetail}/>
                  <Route path="/me" exact component={Me} />
                  <Route path="/" component={Main}/>
                </Switch>
              </Flex>
            </Router>
          </Theme>
        </ApolloProviderHooks>
      </ApolloProvider>
    )
  }
}

ReactDOM.render(
  <App/>,
  document.getElementById("react-app")
)
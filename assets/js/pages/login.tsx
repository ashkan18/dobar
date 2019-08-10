import * as React from "react"
import { Button, Input, Join, Spacer, Box, Spinner } from "@artsy/palette"
import { Link } from 'react-router-dom';
import AuthService from "../services/authService";
import Header from "../components/header";
import { Redirect } from "react-router";
import { useMutation } from '@apollo/react-hooks';
import gql from "graphql-tag";
import { useState } from "react";

const LOGIN = gql`
  mutation Login($username: String!, $password: String!) {
    login(username: $username, password: $password) {
      token
    }
  }
`;

const Login = () => {
  const [username, setUserName] = useState('')
  const [password, setPassword] = useState('')
  const [login, { data, loading, error }] = useMutation(LOGIN)
  if (data && data.login.token) {
    (new AuthService).setToken(data.token)
    return <Redirect to={'/'}/>
  }
  return(
    <>
      <Header noLogin={true}/>
      <Box m={3} mt={6}>
        <Join separator={<Spacer m={1} />}>
          <Input onChange={e => setUserName(e.currentTarget.value)} placeholder="Username"/>
          <Input onChange={e => setPassword(e.currentTarget.value)} placeholder="Password" type="password"/>
          <Button size="medium" onClick={ _e => login({variables: {username, password}}) }>
          {loading ? <Spinner /> : "Login"}</Button>
          <>Don't have an account? click <Link to={'/signup'}>here</Link></>
          { error && <> Invalid username or password, please try again. </> }
        </Join>
      </Box>
    </>
  )
}

export default Login
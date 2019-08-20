import * as React from "react"
import { Button, Input, Join, Spacer, Box, Spinner } from "@artsy/palette"
import AuthService from "../services/authService"
import gql from "graphql-tag";
import Header from "../components/header";
import { Redirect } from "react-router";
import { useState } from "react";
import { useMutation } from "@apollo/react-hooks";

const SIGNUP_MUTATION = gql`
  mutation signup($username: String!, $password: String!, $passwordConfirmation: String!, $name: String!, $email: String!){
    signup(username: $username, password: $password, passwordConfirmation: $passwordConfirmation, name: $name, email: $email){
      token
    }
  }
`

export const SignUp = () => {
  const authService = new AuthService()
  const [username, setUserName] = useState("")
  const [password, setPassword] = useState("")
  const [passwordConfirmation, setPasswordConfirmation] = useState("")
  const [name, setName] = useState("")
  const [email, setEmail] = useState("")
  const [signUp, { data, loading, error }] = useMutation(SIGNUP_MUTATION)
  if (data) {
    authService.setToken(data.signup.token)
    return(<Redirect to={'/'} />)
  }
  return(
    <>
      <Header noLogin={true} />
      <Box m={3} mt={6}>
        <Join separator={<Spacer m={1} />}>
          {error}
          <Input type="text" onChange={e => setName(e.currentTarget.value)} title="Name" value={name} />
          <Input type="text" onChange={e => setUserName(e.currentTarget.value)} title="Username" value={username} />
          <Input type="email" onChange={e => setEmail(e.currentTarget.value)} title="Email" value={email} />
          <Input type="password" onChange={e => setPassword(e.currentTarget.value)} title="Password" value={password} />
          <Input type="password" onChange={e => setPasswordConfirmation(e.currentTarget.value)} title="Password Confirmation" value={passwordConfirmation} />
          <Button size="medium" onClick={_e => signUp({ variables: { name: name, username: username, email: email, password: password, passwordConfirmation: passwordConfirmation } })} mt={1}>Signup!</Button>
          {loading && <Spinner/>}
        </Join>
      </Box>
    </>
  )
}

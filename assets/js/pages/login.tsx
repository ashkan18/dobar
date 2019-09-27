import * as React from "react"
import { Button, Input, Join, Spacer, Spinner, Modal } from "@artsy/palette"
import AuthService from "../services/authService";
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
  const [showModal, setShowModal] = useState(true)
  const [login, { data, loading, error }] = useMutation(LOGIN)
  if (data && data.login.token) {
    (new AuthService).setToken(data.login.token)
    setShowModal(false)
    window.location.reload()
    return(<Spinner/>)
  }
  return(
    <Modal
      title="Login"
      show={showModal}
      isWide
      onClose={() => setShowModal(false)}
      >
      <Join separator={<Spacer m={1} />}>
        <Input onChange={e => setUserName(e.currentTarget.value)} placeholder="Username"/>
        <Input onChange={e => setPassword(e.currentTarget.value)} placeholder="Password" type="password"/>
        <Button size="medium" onClick={ _e => login({variables: {username, password}}) }>
        {loading ? <Spinner /> : "Login"}</Button>
        { error && <> Invalid username or password, please try again. </> }
      </Join>
    </Modal>
  )
}

export default Login
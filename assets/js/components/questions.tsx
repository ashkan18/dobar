import * as React from "react"
import { Spinner, Flex, Sans } from "@artsy/palette"

import gql from "graphql-tag";
import { useMutation, useQuery } from "@apollo/react-hooks";
import { useState } from "react";
import { Link } from "react-router-dom";
import styled from "styled-components";

interface Props {
  place: any
  user: any
}

const DOBAR_MUTATION  = gql`
  mutation Dobar($placeId: ID!, $response: Boolean) {
    dobar(placeId: $placeId, response: $response) {
      id
    }
  }
`
const RIDESHARE_DOBAR_MUTATION  = gql`
  mutation Rideshare($placeId: ID!, $response: Boolean) {
    rideshareDobar(placeId: $placeId, response: $response) {
      id
    }
  }
`

export const Questions = (props: Props) => {
  const {user, place} = props
  const [haveBeenToPlace, setHaveBeenToPlace] = useState(false)
  const [dobar, setDobar] = useState()
  const [rideshare, setRideshare] = useState()
  const [dobarMutation, { loading: dobarLoading, error: dobarError }] = useMutation(DOBAR_MUTATION)
  const [rideshareMutation, { loading: rideshareLoading, error: rideshareError }] = useMutation(RIDESHARE_DOBAR_MUTATION)
  const dobarResponse = (response: boolean) => {
    dobarMutation({variables: {placeId: place.id, response: response}})
    setDobar(response)
  }
  const rideshareResponse = (response: boolean) => {
    rideshareMutation({variables: {placeId: place.id, response: response}})
    setRideshare(response)
  }
  if (user) {
    const {myReview} = place
    if (myReview !== null && myReview.length > 0) {
      return(
        <Sans size={2} mt={2} m={"auto"}>You have already reviewed this place! Thank you!</Sans>
      )
    }
    return(
      <Flex flexDirection="column" justifyContent="space-between" mt={2} m={"auto"}>
        <Flex flexDirection="row">
          <Sans size={5}>{user && `${user.name}, `} Have you been to {place.name}?</Sans>
          <QuestionResponse size={5} ml={2} opacity={haveBeenToPlace === true ? 1 : 0.2} onClick={ _e => setHaveBeenToPlace(true)}> Yes </QuestionResponse>
        </Flex>
        {haveBeenToPlace &&
          <Flex flexDirection="row">
            <Sans size={5}>Would you go to this place again?</Sans>
            <QuestionResponse size={5} ml={2} opacity={dobar === true ? 1 : 0.2} onClick={ _e => dobarResponse(true)}> Yes </QuestionResponse>
            <QuestionResponse size={5} ml={2} opacity={dobar === false ? 1 : 0.2} onClick={ _e => dobarResponse(false)}> No </QuestionResponse>
            {dobarLoading && <Spinner/>}
          </Flex>
        }
        {dobar &&
          <Flex flexDirection="row">
            <Sans size={5}>You are 3 miles away from {place.name}, would you use a rideshare service to go there?</Sans>
            <QuestionResponse size={5} ml={2} opacity={rideshare === true ? 1 : 0.2} onClick={ _e => rideshareResponse(true)}> Yes </QuestionResponse>
            <QuestionResponse size={5} ml={2} opacity={rideshare === false ? 1 : 0.2} onClick={ _e => rideshareResponse(false)}> No </QuestionResponse>
            {rideshareLoading && <Spinner/>}
          </Flex>
        }
      </Flex>
    )
  } else {
    return(
      <Flex flexDirection="column" justifyContent="space-between" mt={2}>
        <Sans size={3}> Please <Link to="/login">Login</Link> to check in.</Sans>
      </Flex>
    )
  }
}

const QuestionResponse = styled(Sans)`
    text-decoration: none;
    cursor: pointer;

    &:focus, &:hover {
        text-decoration: underline;
    }
`;

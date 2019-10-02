import * as React from "react"
import { Sans, Flex, Input, Button, Box, Spinner } from "@artsy/palette";
import { useState } from "react";
import gql from "graphql-tag";
import { useLazyQuery, useMutation } from "@apollo/react-hooks";

export interface Props{
  onFinish(): void
}


const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $address: String, $term: String) {
    places(first: 30, location: $location, address: $address, term: $term){
      edges{
        node{
          id
          name
          workingHours
          tags
          images {
            urls {
              original
              thumb
            }
          }
        }
      }
    }
  }
`

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
export const Onboarding = (props: Props) => {
  const {onFinish} = props
  const [step, setStep] = useState(0)
  const [address, setAddress] = useState("")
  const [search, { called, loading, error: queryError, data }] = useLazyQuery(FIND_PLACES)
  const [currentPlace, setCurrentPlace] = useState()
  const [places, setPlaces] = useState()
  const [responseCount, setResponseCount] = useState(0)
  const [haveBeenToPlace, setHaveBeenToPlace] = useState(false)
  const [dobar, setDobar] = useState(false)
  const [dobarMutation, { loading: dobarLoading, error: dobarError }] = useMutation(DOBAR_MUTATION)
  const [rideshareMutation, { loading: rideshareLoading, error: rideshareError }] = useMutation(RIDESHARE_DOBAR_MUTATION)


  const haveBeen = () => {
    setHaveBeenToPlace(true)
  }

  const goNext = () => {
    setCurrentPlace(places.pop())
    setHaveBeenToPlace(false)
    setDobar(false)
  }

  const wouldDobar = (response: boolean) => {
    setResponseCount(responseCount + 1)
    if (response ) {
      dobarMutation({variables: {placeId: currentPlace.id, response: response}})
      setDobar(true)
    } else {
      goNext()
    }
    if (responseCount === 3) {
      setStep(2)
      setTimeout(onFinish, 5000);
    }
  }

  const wouldRideshare = (response: boolean) => {
    if (response ) {
      rideshareMutation({variables: {placeId: currentPlace.id, response: response}})
    }
    goNext()
  }

  const findPlaces = () => {
    search({variables: { address }})
  }

  if (data && step === 0 && !places) {
    setStep(1)
    const placesResponse = data.places.edges.reverse().map(p => p.node)
    setPlaces(placesResponse)
    setCurrentPlace(placesResponse.pop())
  }


  return (
    <Box>
      {step === 0 &&
        <>
          <Sans size={4}>What is your favorite neighborhood?</Sans>
          <Flex flexDirection="row" mt={0}>
            <Input placeholder="Address/Neighborhood" onChange={ e => setAddress(e.currentTarget.value) } value={address || ""} />
            { loading ? <Spinner /> : <Button onClick={() => findPlaces()}>Next</Button>}
          </Flex>
        </>
      }
      {step === 1 &&
        <>
          {!haveBeenToPlace &&
            <>
              <Sans size={4}>Have you been to {currentPlace.name}?</Sans>
              <Flex flexDirection="row" mt={1} justifyContent="space-between">
                <Button onClick={haveBeen}>Yes! of course!</Button>
                <Button onClick={goNext}>Nope!</Button>
              </Flex>
            </>
          }
          {haveBeenToPlace && !dobar &&
            <>
              <Sans size={4}>Nice! would you go back to {currentPlace.name}?</Sans>
              <Flex flexDirection="row" mt={1} justifyContent="space-between">
                <Button onClick={() => wouldDobar(true)}>Yes!</Button>
                <Button onClick={() => wouldDobar(false)}>Nope!</Button>
              </Flex>
            </>
          }
          {dobar &&
            <>
              <Sans size={4}>Cool! You are 3 miles away, Would you take a rideshare to {currentPlace.name}?</Sans>
              <Flex flexDirection="row" mt={1} justifyContent="space-between">
                <Button onClick={() => wouldRideshare(true)}>Yes!</Button>
                <Button onClick={() => wouldRideshare(false)}>Nope!</Button>
              </Flex>
            </>
          }
        </>
      }
      {step === 3 &&
        <Sans size={4}>Thanks for letting us know about your taste! Lets start browsing.</Sans>
      }
    </Box>
  )
}

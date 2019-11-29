
import React, { useState } from "react"
import { BorderBox, Checkbox, Button, Input, Box, Sans, Separator } from "@artsy/palette"
import { useLazyQuery } from "@apollo/react-hooks"
import gql from "graphql-tag"
import { PlaceBrick } from "./placeBrick"

const FIND_PLACES = gql`
  query findNewPlaces($otherUsernames: [String], $beingAdventurous: Boolean) {
    findUsNewPlaces(first: 5, otherUsernames: $otherUsernames, beingAdventurous: $beingAdventurous){
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

export const DiscoverPlaces = () => {
  const [otherUsernames, setOtherUsernames] = useState([""])
  const addUsername = (username: string) => {
    setOtherUsernames(otherUsernames.concat([username]))
  }
  const setUsername = (index: number, username: string) => {
    otherUsernames[index] = username
    setOtherUsernames(otherUsernames)
  }
  const [beingAdventurous, setBeingAdventurous] = useState(false)

  const [findPlace, { called, loading, error: queryError, data }] = useLazyQuery(FIND_PLACES)
  if (data) console.log(data.findUsNewPlaces)

  return(
    <Box m={2} flexDirection={"column"}>
      <Sans size={5} weight={"bold"}>Find us a place</Sans>
      <Separator mb={2}/>
      {otherUsernames.map( (ge, index) => <Input type="email" key={index} description="Your friend's email" onChange={e =>  setUsername(index, e.currentTarget.value)}/>)}
      <Checkbox selected={beingAdventurous}>Do you feel adventurous?</Checkbox>
      <Button size="small" variant={"secondaryOutline"} onClick={ _e => addUsername("") }>Add</Button>
      <Button size="small" m={2} onClick={() => findPlace({variables: {otherUsernames, beingAdventurous}})}>Find</Button>
      {data &&
        <PlaceBrick key={data.findUsNewPlaces.edges[0].node.id} place={data.findUsNewPlaces.edges[0].node}/>
      }
    </Box>
  )
}
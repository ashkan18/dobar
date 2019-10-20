import * as React from "react"
import { Flex, Spinner, Sans, Separator } from "@artsy/palette"
import gql from "graphql-tag";
import PlacesWall from "../components/placesWall";
import { useQuery } from "@apollo/react-hooks";
import { useState } from "react";
import { InvitationList } from "../components/invitationList";

const MY_LIST = gql`
  query Me {
      me{
        name
        lists(first: 10){
          edges{
            node{
              listType
              place {
                id
                name
                location
                tags
                images {
                  urls {
                    thumb
                    original
                  }
                }
              }
            }
          }
        }
        invitations(first: 50) {
          edges {
            node {
              id
              host {
                id
                name
              }
              place {
                id
                name
                location
                tags
                images {
                  urls {
                    thumb
                    original
                  }
                }
              }
            }
          }
        }
        invites(first: 50) {
          edges {
            node {
              id
              status
              guestEmail
              place {
                id
                name
                location
                tags
                images {
                  urls {
                    thumb
                    original
                  }
                }
              }
            }
          }
        }
      }
    }
`



export const Me = () => {
  const { loading, data } = useQuery(MY_LIST)
  const [invites, setInvites] = useState({})
  const [invitations, setInvitations] = useState({})
  React.useEffect(() => {
    if (data) {
      const invites = data.me.invites.edges.map(e => e.node).reduce(
        (groupedInvites: any, i: any) => ({
          ...groupedInvites,
          [i.place.id]: [
            ...(groupedInvites[i.place.id] || []),
            i,
          ],
        }),
        {},
      )
      setInvites(invites)

      const invitations = data.me.invitations.edges.map(e => e.node).reduce(
        (groupedInvites: any, i: any) => ({
          ...groupedInvites,
          [i.place.id]: [
            ...(groupedInvites[i.place.id] || []),
            i,
          ],
        }),
        {},
      )
      setInvitations(invitations)
    }
  }, [data])

  return (
    <Flex flexDirection="column">
      { loading && <Spinner/>}
      { !loading && data && data.me &&
        <>
          <Sans size={5}>My List</Sans>
          <Separator width={70}/>
          { data.me.lists.edges.length > 0 && <PlacesWall places={data.me.lists.edges.map(l => l.node.place)}/> }
          { data.me.lists.edges.length == 0 && <Sans size={3} mt={1}>Nothing currently in your favorite list.</Sans> }
          <InvitationList title="Invitations" invitations={invitations}/>
          <InvitationList title="Invites" invitations={invites}/>
        </>
      }
    </Flex>
  )
}

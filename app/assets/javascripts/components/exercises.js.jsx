var Exercises = React.createClass({
  render: function(){
    var exerciseNodes = this.props.exercises.map(function(exercise) {
      return (
        <Exercise key={exercise.id} exercise={exercise} />
      );
    });
    return (
      <div>
        {exerciseNodes}
      </div>
    );
  }
});


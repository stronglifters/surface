var Exercises = React.createClass({
  render: function(){
    var exerciseNodes = this.props.exercises.map(function(exercise) {
      return (
        <Exercise key={exercise.id} exercise={exercise} />
      );
    });
    return (
      <ul className="accordion" data-accordion data-multi-expand="true" data-allow-all-closed="true">
        {exerciseNodes}
      </ul>
    );
  }
});

